//
//  MackaPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 22.06.2023.
//



import UIKit
import Kingfisher

final class MackaPaywallViewController: BasePaywallController {
    private lazy var centerImageView = makeCenterImageView()
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = makeInfoListView()
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.trialInfo, priceList: self.priceList)
    private lazy var trialPurchaseButton = makeTrialPurchaseButton()
    private lazy var purchaseButton = makePurchaseButton()
    
    private let designModel: MackaModel
    
    init(designModel: MackaModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel, priceList: priceList)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let animationType = AnimationType(rawValue: designModel.subscribeButtons.first?.animation ?? "")
            if let animationType = animationType {
                AnimationManager.shared.startAnimation(animationType, on: self.trialPurchaseButton)
            }
        }
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(centerImageView)
        view.addSubview(titleLabel)
        view.addSubview(listView)
        view.addSubview(priceInfoLabel)
        view.addSubview(trialPurchaseButton)
        view.addSubview(purchaseButton)
        
        centerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(view.bounds.height / 3)).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(view.bounds.height / 5.5)).isActive = true
        
        listView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        priceInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        priceInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: trialPurchaseButton.topAnchor, constant: -10).isActive = true
        
        if designModel.subscribeButtons.first?.animation == "" {
            trialPurchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            trialPurchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            trialPurchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            trialPurchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        trialPurchaseButton.heightAnchor.constraint(equalTo: purchaseButton.heightAnchor).isActive = true
        trialPurchaseButton.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -20).isActive = true
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -70).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
    }
}
private extension MackaPaywallViewController {
    func makeInfoListView() -> InfoListView {
        let view = InfoListView(infoList: designModel.infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func makeCenterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: designModel.centerImage) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }
    func makeTrialPurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didTrialPurchaseButtonTap), for: .touchUpInside)
        return button
    }
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButtonWithPrice(model: designModel.subscribeButtons[1], priceList: self.priceList)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}
// MARK: - UI Actions
private extension MackaPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons[1].productId)
    }
    @objc
    func didTrialPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
