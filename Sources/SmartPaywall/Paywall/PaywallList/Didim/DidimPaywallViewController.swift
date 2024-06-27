//
//  DidimViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 23.06.2023.
//

import UIKit

final class DidimPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = makeInfoListView()
    //private lazy var listImageView = makeInfoImageView()
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo, priceList: self.priceList)
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var purchaseButton = makePurchaseButton()
    
    private let designModel: DidimModel
    
    init(designModel: DidimModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel, priceList: priceList)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let animationType = AnimationType(rawValue: designModel.subscribeButtons.first?.animation ?? "")
            if let animationType = animationType {
                AnimationManager.shared.startAnimation(animationType, on: self.purchaseButton)
            }
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(titleLabel)
        view.addSubview(listView)
       // view.addSubview(listImageView)
        view.addSubview(priceInfoLabel)
        view.addSubview(trialInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(cancelInfoLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(view.bounds.height / 3.5)).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
   
        listView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        listView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
        trialInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        trialInfoLabel.bottomAnchor.constraint(equalTo: priceInfoLabel.topAnchor, constant: -20).isActive = true
        
        priceInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        priceInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
      
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        
        
        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
}

private extension DidimPaywallViewController {
    
    func makeInfoListView() -> InfoTextListView {
        let view = InfoTextListView(infoList: designModel.infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}

// MARK: - UI Actions
private extension DidimPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
