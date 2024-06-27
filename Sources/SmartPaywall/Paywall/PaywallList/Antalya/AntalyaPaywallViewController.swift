//
//  AntalyaPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 22.06.2023.
//

import UIKit
import Kingfisher

final class AntalyaPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = makeInfoListView()
    private lazy var listImageView = makeListImageView()
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                               priceList: self.priceList)
   
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var purchaseButton = makePurchaseButton()
    
    private let designModel: AntalyaModel
    
    init(designModel: AntalyaModel,
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
        view.addSubview(trialInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(priceInfoLabel)
        view.addSubview(listImageView)
        
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(view.bounds.height / 5.5)).isActive = true
        
        listView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        listImageView.topAnchor.constraint(equalTo: listView.bottomAnchor, constant: 10).isActive = true
        listImageView.leadingAnchor.constraint(equalTo: listView.leadingAnchor).isActive = true
        listImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        listImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        priceInfoLabel.topAnchor.constraint(equalTo: listImageView.topAnchor).isActive = true
        priceInfoLabel.leadingAnchor.constraint(equalTo: listImageView.trailingAnchor, constant: 5).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: listView.trailingAnchor).isActive = true
        
        trialInfoLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        trialInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true
        
        if designModel.subscribeButtons.first?.animation == "" {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        }
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -70).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        
    }
}

private extension AntalyaPaywallViewController {
    func makeInfoListView() -> InfoListView {
        let view = InfoListView(infoList: designModel.infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeListImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let url = URL(string: designModel.listImage) {
            imageView.kf.setImage(with: url)
        }
        return imageView
    }
    
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }

}
// MARK: - UI Actions
private extension AntalyaPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
