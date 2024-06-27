//
//  UludagPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 24.01.2024.
//

import UIKit
import Kingfisher

final class UludagPaywallViewController: BasePaywallController {
    private lazy var headerStackView = makeHeaderStackView()
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var infoListView = UIFactory.makeInfoListView(infoList: designModel.infoList)
    
    private lazy var productSelectionView: VerticalSelectionView = {
        let view = VerticalSelectionView(model: designModel.subscription.option,
                                                priceList: self.priceList)
        view.didSelect = { [weak self] productId in
            self?.selectedProductId = productId
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var purchaseButton = makePurchaseButton()
    
    private var selectedProductId = ""
    
    private let designModel: UludagModel
    
    init(designModel: UludagModel,
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
        
        view.addSubview(headerStackView)
        view.addSubview(productSelectionView)
        view.addSubview(purchaseButton)
        view.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 25).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        //titleLabel.bottomAnchor.constraint(equalTo: headerStackView.topAnchor, constant: -15).isActive = true
        
        headerStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        headerStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        headerStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        headerStackView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(infoListView)
        
        productSelectionView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor).isActive = true
        productSelectionView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor).isActive = true
        productSelectionView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -25).isActive = true
        //productSelectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 100).isActive = true
        productSelectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.30).isActive = true
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscription.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -30).isActive = true
    }
}

private extension UludagPaywallViewController {
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
private extension UludagPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(selectedProductId)
    }
}
