//
//  ÇeşmeViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 21.06.2023.
//

import UIKit

final class CesmePaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var subTitleLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                               priceList: self.priceList)
    private lazy var listInfotextLabel = UIFactory.makeLabel(model: designModel.listInfotext)
    private lazy var listView = makeInfoListView()
    private lazy var unlockInfoView = makeUnlockInfoListView()
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    
    private let designModel: CesmeModel
    
    init(designModel: CesmeModel,
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
        view.addSubview(subTitleLabel)
        view.addSubview(listInfotextLabel)
        view.addSubview(listView)
        view.addSubview(unlockInfoView)
        view.addSubview(purchaseButton)
        view.addSubview(cancelInfoLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(view.bounds.height / 4)).isActive = true
        
        subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        subTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        
        listInfotextLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        listInfotextLabel.bottomAnchor.constraint(equalTo: listView.topAnchor, constant: -20).isActive = true
        
        listView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        listView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        listView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 30).isActive = true
        
        unlockInfoView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        unlockInfoView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -25).isActive = true
        
        if designModel.subscribeButtons.first?.animation == "" {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        
        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
}

private extension CesmePaywallViewController {
    func makeInfoListView() -> InfoListView {
        let view = InfoListView(infoList: designModel.infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func makeUnlockInfoListView() -> HorizontalInfoListView {
        let view = HorizontalInfoListView(infoList: designModel.unlockInfo)
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
private extension CesmePaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
