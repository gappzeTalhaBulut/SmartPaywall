//
//  BodrumPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 2.08.2023.
//

import UIKit

final class BodrumPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = makeInfoListView()
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo, priceList: self.priceList)
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var centerImageView = makeCenterImageView()
    
    private let designModel: BodrumModel
    
    init(designModel: BodrumModel,
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
        view.addSubview(priceInfoLabel)
        view.addSubview(trialInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(cancelInfoLabel)
        view.addSubview(centerImageView)
        
        // titleLabel'ı merkeze yerleştir
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height / 8.5).isActive = true

        // centerImageView'ı sol üst köşeye yerleştir
        var heightMultiplier: CGFloat = 1/2.85

        if UIScreen.main.bounds.height == 667 { // iPhone 8 yüksekliği
            heightMultiplier = 1/2.5
        }
        centerImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        centerImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        centerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: heightMultiplier).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true

        listView.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: 20).isActive = true
        listView.topAnchor.constraint(equalTo: centerImageView.topAnchor).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45).isActive = true
        listView.heightAnchor.constraint(equalTo: centerImageView.heightAnchor, constant: 0).isActive = true
        
        trialInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        trialInfoLabel.bottomAnchor.constraint(equalTo: priceInfoLabel.topAnchor, constant: -10).isActive = true
        
        priceInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        priceInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
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
private extension BodrumPaywallViewController {
    
    func makeInfoListView() -> InfoTextListViewForBodrum {
        let view = InfoTextListViewForBodrum(infoList: designModel.infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
    func makeCenterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: designModel.centerImage) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }
}

// MARK: - UI Actions
private extension BodrumPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
