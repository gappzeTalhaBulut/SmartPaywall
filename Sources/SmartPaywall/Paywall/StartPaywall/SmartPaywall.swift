// The Swift Programming Language
// https://docs.swift.org/swift-book

import AlertKit
import StoreKit
import Foundation

public enum StoreKitError: Error {
    case unknown
    case invalidProductIdentifier(productID: String)
    case userCancelled
    case paymentNotAllowed
    case productUnavailable
    
    public var code: Int {
        switch self {
        case .unknown:
            return 1000
        case .invalidProductIdentifier:
            return 1001
        case .userCancelled:
            return 1002
        case .paymentNotAllowed:
            return 1003
        case .productUnavailable:
            return 1004
        }
    }
    
    public var description: String {
        switch self {
        case .unknown:
            return "Bilinmeyen bir hata oluştu."
        case .invalidProductIdentifier(let productID):
            return "Geçersiz product id: \(productID)"
        case .userCancelled:
            return "Kullanıcı işlemi iptal etti."
        case .paymentNotAllowed:
            return "Ödeme izni verilmedi."
        case .productUnavailable:
            return "Bu product kullanılamıyor"
        }
    }
}

public typealias Transaction = StoreKit.Transaction
public typealias OnOpenCompletion = (_ paywallId: Int, _ isABTest: Bool, _ abTestName: String) -> ()
public typealias notCloseCompletion = (_ placementID: Int, _ isABTest: Bool, _ errorText: String) -> ()
public typealias OnPurchaseSuccess = (_ purchaseTransactionId: String, _ paywallId: Int, _ productId: String, _ isABTest: Bool, _ abTestName: String) -> ()
public typealias OnPurchaseFailed = (_ paywallId: Int, _ isABTest: Bool, _ abTestName: String, _ productCode: String, _ errorCode: String, _ errorDetail: String) -> ()


public class PaywallService {
    public static let shared = PaywallService()
    
    private var productIDs: Set<String> = []
    private var network: NetworkProtocol = NetworkService()
    
    private init() {
        FontRegister.loadFonts()
    }
    
    public var products: [Product] = []
    @Published private(set) var isPremiumSubscriber: Bool = false
    private weak var currentPaywallController: (any ControllerType)?
    
    public static func configure(unique: String, bundle: String, country: String, lang: String, version: String, isTest: Bool, serviceURL: String, serviceToken: String, fallbackProductIDs: Set<String>) async {
        await shared.getProductIDsFromService(
            unique: unique,
            bundle: bundle,
            country: country,
            lang: lang,
            version: version,
            isTest: isTest,
            serviceURL: serviceURL,
            serviceToken: serviceToken,
            fallbackProductIDs: fallbackProductIDs
        )
    }
    
    public func initialize() async {
        await startObservingTransactions()
        await fetchProducts()
        await updateSubscriptionStatus()
    }
    
    public func fetchProducts() async {
        do {
            let newProducts = try await Product.products(for: productIDs).sorted(by: {$0.price > $1.price })
            DispatchQueue.main.async {
                self.products = newProducts
                debugPrint(self.products.map {$0.displayPrice})
            }
        } catch {
            print("Failed to load products: \(error)")
        }
    }
    /// Servisten ilgili uygulamaya göre product id leri al
    private func getProductIDsFromService(unique: String, bundle: String, country: String, lang: String, version: String, isTest: Bool, serviceURL: String, serviceToken: String, fallbackProductIDs: Set<String>) async {
        let model = ProductsModel(
            uniqueId: unique,
            bundle: bundle,
            country: country,
            language: lang,
            version: version,
            isTest: isTest
        )
        await withCheckedContinuation { continuation in
            self.network.request(route: GetProductsRouter.products(model: model, serviceURL: serviceURL, serviceToken: serviceToken)) { [weak self] (result: Result<ProductResponse, NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.productIDs = Set(response.subscriptionProducts)
                    debugPrint("Products fetched successfully: \(response.subscriptionProducts)")
                    continuation.resume()
                case .failure(let error):
                    debugPrint("Error fetching product IDs, using fallback IDs: \(error)")
                    self.productIDs = fallbackProductIDs
                    continuation.resume()
                }
            }
        }
    }
    
    /// Apple'dan gelen kullanıcı durumunu içerir
    public func checkUser(completion: @escaping (_ isPremium: Bool, _ transactionId: String) -> ()) {
        Task.detached {
            do {
                var transactionId: String? = nil
                var pastTransactionId: String? = nil
                var isPremiumSubscriber = false
                for await result in Transaction.currentEntitlements {
                    let transaction = try self.checkVerified(result)
                    isPremiumSubscriber = true
                    UserDefaults.standard.setValue(true, forKey: "isSubscriber")
                    transactionId = String(transaction.originalID)
                    completion(isPremiumSubscriber, transactionId ?? "")
                    break
                }
                if !isPremiumSubscriber {
                    completion(isPremiumSubscriber, transactionId ?? "")
                    for await result in Transaction.all {
                        do {
                            let transaction = try self.checkVerified(result)
                            pastTransactionId = String(transaction.originalID)
                            UserDefaults.standard.setValue(true, forKey: "isSubscriber")
                            completion(isPremiumSubscriber, pastTransactionId ?? "")
                            break
                        } catch {
                            completion(isPremiumSubscriber, pastTransactionId ?? "")
                            continue
                        }
                    }
                }
            } catch {
                completion(false, "")
            }
        }
    }
    
    public func makePurchase(productID: String,
                             onPurchaseSuccess: @escaping (_ purchaseTransactionId: String, _ productId: String) -> (),
                             onPurchaseFailed: @escaping (_ productCode: String, _ errorCode: String, _ errorDetail: String) -> ()) async throws -> Transaction {
        guard let product = products.first(where: { $0.id == productID }) else {
            let error = StoreKitError.invalidProductIdentifier(productID: productID)
            onPurchaseFailed(productID, "\(error.code)", error.description)
            throw error
        }
        
        do {
            let appAccountToken = UUID()
            let purchaseOption = Product.PurchaseOption.appAccountToken(appAccountToken)
            let result = try await product.purchase(options: [purchaseOption])
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionStatus()
                if let appAccountToken = transaction.appAccountToken {
                    print("App Account Token:", appAccountToken)
                } else {
                    print("App Account Token is nil")
                }
                await transaction.finish()
                let purchaseTransaction = "\(transaction.originalID)"
                onPurchaseSuccess(purchaseTransaction, productID)
                return transaction
            case .userCancelled:
                let error = StoreKitError.userCancelled
                onPurchaseFailed(productID, "\(error.code)", error.description)
                throw error
            case .pending:
                let error = StoreKitError.userCancelled
                onPurchaseFailed(productID, "\(error.code)", error.description)
                throw error
            default:
                let error = StoreKitError.unknown
                onPurchaseFailed(productID, "\(error.code)", error.description)
                throw error
            }
        } catch Product.PurchaseError.purchaseNotAllowed {
            let error = StoreKitError.paymentNotAllowed
            onPurchaseFailed(productID, "\(error.code)", error.description)
            throw error
        } catch Product.PurchaseError.productUnavailable {
            let error = StoreKitError.productUnavailable
            onPurchaseFailed(productID, "\(error.code)", error.description)
            throw error
        } catch {
            let unknownError = StoreKitError.unknown.code
            onPurchaseFailed(productID, "\(unknownError)", "\(error)")
            throw error
        }
    }
    public func startObservingTransactions() async {
        Task.detached {
            for await result in Transaction.updates {
                switch result {
                case .verified(let transaction):
                    print("Doğrulanmış işlem: \(transaction)")
                    await transaction.finish()
                case .unverified(let transaction, let error):
                    print("\(transaction)")
                    print("İşlem hata ile başarısız oldu: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func updateSubscriptionStatus() async {
        do {
            for await result in Transaction.currentEntitlements {
                let transaction = try checkVerified(result)
                print("transaction ->>>>> \(transaction.originalID)")
                isPremiumSubscriber = true
                return
            }
            //kullanıcı premium değil
            isPremiumSubscriber = false
        } catch {
            //Transaction id alınamadı
            isPremiumSubscriber = false
        }
    }
    
    public func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreKitError.unknown
        case .verified(let safe):
            return safe
        }
    }
    
    public func restorePurchases(completion: @escaping () -> ()) {
        Task {
            do {
                try await AppStore.sync()
                
                for await result in Transaction.currentEntitlements {
                    if case let .verified(transaction) = result {
                        // Abonelik doğrulandı, işlemleri gerçekleştir
                        print("Abonelik doğrulandı. TransactionID: \(transaction). İşlemleri gerçekleştir.")
                        self.currentPaywallController?.closePaywall {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                AlertKitAPI.present(title: "Success", style: .iOS17AppleMusic, haptic: .success)
                            }
                            completion()
                            return
                        }
                    }
                }
                // Abonelik bulunamadı
                print("Abonelik bulunamadı.")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AlertKitAPI.present(title: "Premium Not Found!", style: .iOS17AppleMusic, haptic: .error)
                }
            } catch {
                // Hata oluştu
                print("Hata: ", error)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AlertKitAPI.present(title: "Error!", style: .iOS17AppleMusic, haptic: .error)
                }
            }
        }
    }
    
    public func openPaywall(
        parameters: SmartPaywallParameters,
        view: UIViewController,
        onOpen: @escaping OnOpenCompletion,
        onClose: (() -> ())? = nil,
        experimentName: String,
        onPurchaseSuccess: @escaping OnPurchaseSuccess,
        couldNotOpenPaywall: @escaping notCloseCompletion,
        onPurchaseFailed: @escaping OnPurchaseFailed,
        onRestoreSuccess: @escaping () -> ()
    ) {
        self.getPaywall(couldNotPaywallOpen: {
            couldNotOpenPaywall(parameters.placementId, false, "")
        }, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (paywallController, paywallModel, products)):
                self.presentPaywall(
                    view: view,
                    paywallController: paywallController,
                    model: paywallModel,
                    products: products,
                    onOpen: onOpen,
                    onClose: onClose,
                    onPurchaseSuccess: { [weak self] purchaseTransactionId, paywallId, productCode, isABTest, abTestName in
                        self?.currentPaywallController?.closePaywall {
                            onPurchaseSuccess(purchaseTransactionId, paywallId, productCode, isABTest, abTestName)
                        }
                    },
                    onPurchaseFailed: onPurchaseFailed,
                    onRestoreSuccess: onRestoreSuccess
                )
            case .failure(let error):
                couldNotOpenPaywall(parameters.placementId, false, error.localizedDescription)
                print(error)
            }
        }
    }
}

public extension PaywallService {
    func fetchPaywall(
        parameters: SmartPaywallParameters,
        completion: @escaping (Result<SmartPaywallResponse, NetworkError>) -> Void
    ) {
        let model = SmartPaywallModel(
            placementId: parameters.placementId,
            action: parameters.action,
            uniqueId: parameters.uniqueId,
            bundle: parameters.bundle,
            country: parameters.country,
            language: parameters.language,
            paywallVersion: parameters.paywallVersion,
            version: parameters.version,
            isTest: parameters.isTest
        )
        
        self.network.request(
            route: SmartPaywallRouter.smartPaywall(
                model: model,
                serviceURL: parameters.serviceURL,
                serviceToken: parameters.serviceToken
            )
        ) { [weak self] (response: Result<SmartPaywallResponse, NetworkError>) in
            guard self != nil else { return }
            switch response {
            case .success(let response):
                debugPrint(response)
                completion(.success(response))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    
    func getPaywall(
        couldNotPaywallOpen: @escaping (() -> Void),
        parameters: SmartPaywallParameters,
        completion: @escaping ((Result<(any ControllerType, SmartPaywallResponse, [Product]), Error>) -> Void)
    ) {
        self.fetchPaywall(parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paywallModel):
                DispatchQueue.main.async {
                    let controller = paywallModel.paywallJson.paywall.designObjects.make(
                        generalModel: paywallModel.paywallJson.paywall.general,
                        priceList: Dictionary(uniqueKeysWithValues: self.products.map { ($0.id, ($0.displayPrice, $0.priceFormatStyle.currencyCode)) })
                    )
                    completion(.success((controller, paywallModel, self.products)))
                }
            case .failure(let error):
                couldNotPaywallOpen()
                completion(.failure(error))
            }
        }
    }
    
    
    func presentPaywall(view: UIViewController,
                        paywallController: any ControllerType,
                        model: SmartPaywallResponse,
                        products: [Product],
                        onOpen: @escaping OnOpenCompletion,
                        onClose: (() -> ())? = nil,
                        onPurchaseSuccess: @escaping OnPurchaseSuccess,
                        onPurchaseFailed: @escaping OnPurchaseFailed,
                        onRestoreSuccess: @escaping () -> ()) {
        // TODO: - Completion kapanma, satınalma ve restore durumlarını unutma
        currentPaywallController = paywallController
        
        currentPaywallController?.onOpen = {
            /// Açılan paywall ' un ABTest olup olmadğını anlamak için ab test adının paywall isminden farklı olmasına bakıyoruz.
            onOpen(model.paywallId, model.ABTestName != model.paywallName, model.ABTestName)
        }
        
        currentPaywallController?.onClose = {
            onClose?()
        }
        
        currentPaywallController?.onPurchase = { [weak self] productId in
            guard let self else { return }
            Task {
                for product in products {
                    if product.id == productId {
                        do {
                            try await self.makePurchase(productID: product.id, onPurchaseSuccess: { purchaseTransactionId, vendorProductId in
                                onPurchaseSuccess(purchaseTransactionId, model.paywallId, vendorProductId, model.ABTestName != model.paywallName, model.ABTestName )
                            }, onPurchaseFailed: { productCode, errorCode, errorDetail in
                                onPurchaseFailed(model.paywallId, model.ABTestName != model.paywallName, model.ABTestName, productCode, errorCode, errorDetail)
                            })
                        } catch {
                            // Burada hata yönetimi yapabilirsiniz
                            print("Purchase failed with error: \(error)")
                        }
                        break
                    }
                }
            }
        }
        
        currentPaywallController?.onRestore = { [weak self] in
            guard let self = self else { return }
            self.restorePurchases {
                onRestoreSuccess()
            }
        }
        currentPaywallController?.modalTransitionStyle = !UserDefaults.standard.bool(forKey: "homeViewed") ? .crossDissolve : .coverVertical
        currentPaywallController?.modalPresentationStyle = .fullScreen
        view.present(self.currentPaywallController!, animated: true)
        
    }
}

/// TEST LAYER
extension PaywallService {
    func fetchTestPaywall(
        parameters: TestPaywallParameters,
        completion: @escaping (Result<TestPaywallResponse, NetworkError>) -> Void
    ) {
        let model = TestPaywallModel(
            paywallId: parameters.paywallId,
            uniqueId: parameters.uniqueId,
            bundle: parameters.bundle,
            country: parameters.country,
            language: parameters.language,
            paywallVersion: parameters.paywallVersion,
            version: parameters.version,
            isCdn: parameters.isCdn
        )
        
        self.network.request(
            route: TestPaywallRouter.smartPaywall(
                model: model,
                serviceURL: parameters.serviceURL,
                serviceToken: parameters.serviceToken
            )
        ) { [weak self] (response: Result<TestPaywallResponse, NetworkError>) in
            guard self != nil else { return }
            switch response {
            case .success(let response):
                debugPrint(response)
                completion(.success(response))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    func getTestPaywall(
        couldNotPaywallOpen: @escaping (() -> Void),
        parameters: TestPaywallParameters,
        completion: @escaping ((Result<(any ControllerType, TestPaywallResponse, [Product]), Error>) -> Void)
    ) {
        self.fetchTestPaywall(parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paywallModel):
                DispatchQueue.main.async {
                    let controller = paywallModel.paywallJson.paywall.designObjects.make(
                        generalModel: paywallModel.paywallJson.paywall.general,
                        priceList: Dictionary(uniqueKeysWithValues: self.products.map { ($0.id, ($0.displayPrice, $0.priceFormatStyle.currencyCode)) })
                    )
                    completion(.success((controller, paywallModel, self.products)))
                }
            case .failure(let error):
                couldNotPaywallOpen()
                completion(.failure(error))
            }
        }
    }
    
    public func openTestPaywall(
        parameters: TestPaywallParameters,
        view: UIViewController,
        onOpen: @escaping OnOpenCompletion,
        onClose: (() -> ())? = nil,
        experimentName: String,
        onPurchaseSuccess: @escaping OnPurchaseSuccess,
        couldNotOpenPaywall: @escaping notCloseCompletion,
        onPurchaseFailed: @escaping OnPurchaseFailed,
        onRestoreSuccess: @escaping () -> ()
    ) {
        self.getTestPaywall(couldNotPaywallOpen: {
            couldNotOpenPaywall(parameters.paywallId, false, "")
        }, parameters: parameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let (paywallController, paywallModel, products)):
                self.presentTestPaywall(
                    view: view,
                    paywallController: paywallController,
                    model: paywallModel,
                    products: products,
                    onOpen: onOpen,
                    onClose: onClose,
                    onPurchaseSuccess: { [weak self] purchaseTransactionId, paywallId, productCode, isABTest, abTestName in
                        self?.currentPaywallController?.closePaywall {
                            onPurchaseSuccess(purchaseTransactionId, paywallId, productCode, isABTest, abTestName)
                        }
                    },
                    onPurchaseFailed: onPurchaseFailed,
                    onRestoreSuccess: onRestoreSuccess
                )
            case .failure(let error):
                couldNotOpenPaywall(parameters.paywallId, false, error.localizedDescription)
                print(error)
            }
        }
    }
    
    func presentTestPaywall(view: UIViewController,
                            paywallController: any ControllerType,
                            model: TestPaywallResponse,
                            products: [Product],
                            onOpen: @escaping OnOpenCompletion,
                            onClose: (() -> ())? = nil,
                            onPurchaseSuccess: @escaping OnPurchaseSuccess,
                            onPurchaseFailed: @escaping OnPurchaseFailed,
                            onRestoreSuccess: @escaping () -> ()) {
        // TODO: - Completion kapanma, satınalma ve restore durumlarını unutma
        currentPaywallController = paywallController
        
        currentPaywallController?.onOpen = {
            /// Açılan paywall ' un ABTest olup olmadğını anlamak için ab test adının paywall isminden farklı olmasına bakıyoruz.
            //onOpen(model.paywallId, model.ABTestName != model.paywallName, model.ABTestName)
        }
        
        currentPaywallController?.onClose = {
            onClose?()
        }
        
        currentPaywallController?.onPurchase = { [weak self] productId in
            guard let self else { return }
            Task {
                for product in products {
                    if product.id == productId {
                        do {
                            try await self.makePurchase(productID: product.id, onPurchaseSuccess: { purchaseTransactionId, vendorProductId in
                                //onPurchaseSuccess(purchaseTransactionId, model.paywallId, vendorProductId, model.ABTestName != model.paywallName, model.ABTestName )
                            }, onPurchaseFailed: { productCode, errorCode, errorDetail in
                                //onPurchaseFailed(model.paywallId, model.ABTestName != model.paywallName, model.ABTestName, productCode, errorCode, errorDetail)
                            })
                        } catch {
                            // Burada hata yönetimi yapabilirsiniz
                            print("Purchase failed with error: \(error)")
                        }
                        break
                    }
                }
            }
        }
        
        
        currentPaywallController?.onRestore = { [weak self] in
            guard let self = self else { return }
            self.restorePurchases {
                onRestoreSuccess()
            }
        }
        currentPaywallController?.modalTransitionStyle = !UserDefaults.standard.bool(forKey: "homeViewed") ? .crossDissolve : .coverVertical
        currentPaywallController?.modalPresentationStyle = .fullScreen
        view.present(self.currentPaywallController!, animated: true)
        
    }
}
