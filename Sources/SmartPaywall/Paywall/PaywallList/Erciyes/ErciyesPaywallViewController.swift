//
//  ErciyesPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 30.06.2023.
//

import UIKit
import Kingfisher

final class ErciyesPaywallViewController: BasePaywallController {
    private lazy var centerImageView = makeCenterImageView()
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = makeInfoListView()
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                               priceList: self.priceList)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    
    private let designModel: ErciyesModel
    
    init(designModel: ErciyesModel,
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
        
        view.addSubview(centerImageView)
        view.addSubview(titleLabel)
        view.addSubview(listView)
        view.addSubview(trialInfoLabel)
        view.addSubview(priceInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(cancelInfoLabel)
        
        centerImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 0).isActive = true
        centerImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        centerImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        listView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        listView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4).isActive = true
        // TODO: height anchor a tekrar bakmalısın!!!
        
        trialInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        trialInfoLabel.bottomAnchor.constraint(equalTo: priceInfoLabel.topAnchor, constant: -5).isActive = true
        
        priceInfoLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true
        
        if designModel.subscribeButtons.first?.animation == "" {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        }
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        
        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
}
private extension ErciyesPaywallViewController {
    func makeCenterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: designModel.centerImage) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }
    func makeInfoListView() -> GridInfoListView {
        let view = GridInfoListView(infoList: designModel.infoList)
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
private extension ErciyesPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
