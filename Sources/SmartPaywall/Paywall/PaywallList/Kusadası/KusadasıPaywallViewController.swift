//
//  KusadasıPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 29.01.2024.
//

import UIKit
import Kingfisher

final class KusadasıPaywallViewController: BasePaywallController {
    private lazy var infoListView = UIFactory.makeInfoListView(infoList: designModel.infoList)
    private lazy var cancelLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    private lazy var purchaseButton = makePurchaseButton()
    
    private lazy var productSelectionView: HorizontalSelectionView = {
        let view = HorizontalSelectionView(model: designModel.subscription.option,
                                           priceList: self.priceList)
        view.didSelect = { [weak self] productId in
            self?.selectedProductId = productId
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var selectedProductId = ""
    private let designModel: KusadasıModel
    
    init(designModel: KusadasıModel,
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
        
        view.addSubview(infoListView)
        view.addSubview(productSelectionView)
        view.addSubview(cancelLabel)
        view.addSubview(purchaseButton)
        
        infoListView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        infoListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        //infoListView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            productSelectionView.topAnchor.constraint(equalTo: infoListView.bottomAnchor, constant: 20).isActive = true
            productSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            productSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
            productSelectionView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -30).isActive = true
            productSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        } else {
            productSelectionView.topAnchor.constraint(equalTo: infoListView.bottomAnchor, constant: 20).isActive = true
            productSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            productSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            productSelectionView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -30).isActive = true
            productSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2).isActive = true
        }
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscription.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: cancelLabel.topAnchor, constant: -10).isActive = true
        
        cancelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -15).isActive = true
    }
}
private extension KusadasıPaywallViewController {
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
private extension KusadasıPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(selectedProductId)
    }
}
