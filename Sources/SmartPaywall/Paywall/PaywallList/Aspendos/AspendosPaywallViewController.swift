//
//  AspendosPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 26.01.2024.
//

import UIKit

final class AspendosPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var subtitleLabel = UIFactory.makeLabel(model: designModel.subtitle)
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                                    priceList: self.priceList)
    private lazy var purchaseButton = makePurchaseButton()
    
    private lazy var timeView: UIView = {
        //let view = CountdownView(frame: .zero, initialValue: designModel.timerValue)
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let designModel: AspendosModel
    
    init(designModel: AspendosModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel,
                   priceList: priceList)
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
        view.addSubview(trialInfoLabel)
        view.addSubview(priceInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(subtitleLabel)
        view.addSubview(timeView)
        
        titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
        subtitleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        subtitleLabel.bottomAnchor.constraint(equalTo: timeView.topAnchor, constant: -10).isActive = true
       
        timeView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        timeView.bottomAnchor.constraint(equalTo: trialInfoLabel.topAnchor, constant: -15).isActive = true
        timeView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.38).isActive = true
        timeView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        trialInfoLabel.leadingAnchor.constraint(equalTo: priceInfoLabel.leadingAnchor).isActive = true
        trialInfoLabel.trailingAnchor.constraint(equalTo: priceInfoLabel.trailingAnchor).isActive = true
        trialInfoLabel.bottomAnchor.constraint(equalTo: priceInfoLabel.topAnchor, constant: -7).isActive = true
        
        priceInfoLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -15).isActive = true
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -48).isActive = true
    }
}


private extension AspendosPaywallViewController {
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}

// MARK: - UI Actions
private extension AspendosPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
