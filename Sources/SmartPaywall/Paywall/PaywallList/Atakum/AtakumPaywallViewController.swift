//
//  AtakumPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talip on 6.07.2023.
//

import UIKit
import Kingfisher

final class AtakumPaywallViewController: BasePaywallController {
    private lazy var headerStackView = makeHeaderStackView()
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var infoListView = UIFactory.makeInfoListView(infoList: designModel.infoList)
    
    private lazy var productSelectionView: VerticalProductSelectionView = {
        let view = VerticalProductSelectionView(model: designModel.subscription.option,
                                                priceList: self.priceList)
        view.didSelect = { [weak self] productId in
            self?.selectedProductId = productId
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var purchaseButton = makePurchaseButton()
    
    private var selectedProductId = ""
    
    private let designModel: AtakumModel
    
    init(designModel: AtakumModel,
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
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: headerStackView.topAnchor, constant: -15).isActive = true
        
        headerStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        headerStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        headerStackView.bottomAnchor.constraint(equalTo: productSelectionView.topAnchor, constant: -25).isActive = true
        headerStackView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(infoListView)
        
        productSelectionView.leadingAnchor.constraint(equalTo: headerStackView.leadingAnchor).isActive = true
        productSelectionView.trailingAnchor.constraint(equalTo: headerStackView.trailingAnchor).isActive = true
        productSelectionView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true
        
        if designModel.subscription.subscribeButtons.first?.animation == "" {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
        } else {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        }
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscription.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -30).isActive = true
    }
}

private extension AtakumPaywallViewController {
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
private extension AtakumPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(selectedProductId)
    }
}
