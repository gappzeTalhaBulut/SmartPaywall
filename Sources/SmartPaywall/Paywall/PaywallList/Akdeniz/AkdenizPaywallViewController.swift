//
//  File.swift
//  
//
//  Created by Talha on 11.10.2024.
//

import UIKit

final class AkdenizPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var subtitleLabel = UIFactory.makeLabel(model: designModel.subtitle)
    private lazy var infoListView = UIFactory.makeInfoListView(infoList: designModel.infoList)
    private lazy var cancelInfo = UIFactory.makeLabel(model: designModel.cancelInfo)
    
    private lazy var productSelectionView: VerticalProductSelectionViewAkdeniz = {
        let view = VerticalProductSelectionViewAkdeniz(model: designModel.subscription.option,
                                                priceList: self.priceList)
        view.didSelect = { [weak self] productId in
            self?.selectedProductId = productId
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 20
        return stack
    }()
    private lazy var purchaseButton = makePurchaseButton()
    private var selectedProductId = ""
    private let designModel: AkdenizModel
    
    init(designModel: AkdenizModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel, priceList: priceList)
        findFirstProductIdIfSelected()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let animationType = AnimationType(rawValue: designModel.subscription.subscribeButtons.first?.animation ?? "")
            if let animationType = animationType {
                AnimationManager.shared.startAnimation(animationType, on: self.purchaseButton)
            }
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(cancelInfo)
        view.addSubview(productSelectionView)
        view.addSubview(purchaseButton)
        view.addSubview(stackView)
        //view.addSubview(infoListView)
        
        stackView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
      
       //infoListView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
       //infoListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
       //infoListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
       //infoListView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30).isActive = true
       //// infoListView.bottomAnchor.constraint(equalTo: cancelInfo.topAnchor, constant: -10).isActive = true
        
        cancelInfo.bottomAnchor.constraint(equalTo: productSelectionView.topAnchor, constant: -5).isActive = true
        cancelInfo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        cancelInfo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        productSelectionView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -20).isActive = true
        productSelectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        productSelectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        productSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscription.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -30).isActive = true
    }
}

private extension AkdenizPaywallViewController {
    func makeHeaderStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.spacing = 15
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func findFirstProductIdIfSelected() {
        for product in designModel.subscription.option.productList {
            if product.isSelected {
                self.selectedProductId = product.productId
            }
        }
    }
    
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscription.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}

// MARK: - UI Actions
private extension AkdenizPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(selectedProductId)
    }
}
