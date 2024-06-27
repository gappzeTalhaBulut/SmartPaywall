//
//  MarmarisPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 2.09.2023.
//

import UIKit

final class MarmarisPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var listView = UIFactory.makeInfoListView(infoList: designModel.infoList)
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                               priceList: self.priceList)
    private lazy var trialPriceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo2,
                                                               priceList: self.priceList)
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var trialPurchaseButton = makeTrialPurchaseButton()
    private lazy var trialView = makeTrialView()
    private lazy var trialTitle = UIFactory.makeLabel(model: designModel.trialTitle)
    private lazy var trialSubtitle = UIFactory.makeLabel(model: designModel.trialSubtitle)
    private lazy var viewStack = UIStackView()
    private lazy var switchButton = UISwitch()
    
    private var designModel: MarmarisModel
    
    init(designModel: MarmarisModel,
         generalModel: PaywallGeneralModel,
         priceList: PriceList) {
        self.designModel = designModel
        super.init(generalModel: generalModel,
                   priceList: priceList)
        self.setSwitchDefaultsValues()
        
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
        view.addSubview(trialPriceInfoLabel)
        view.addSubview(cancelInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(trialPurchaseButton)
        view.addSubview(trialView)
        view.addSubview(viewStack)
        trialView.addSubview(switchButton)
        viewStack.addArrangedSubview(trialTitle)
        viewStack.addArrangedSubview(trialSubtitle)
        viewStack.translatesAutoresizingMaskIntoConstraints = false
        viewStack.axis = .vertical
        viewStack.alignment = .leading
        viewStack.spacing = 0
        viewStack.distribution = .fill
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -(view.bounds.height / 7.5)).isActive = true
        
        listView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        listView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        listView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        priceInfoLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: cancelInfoLabel.topAnchor, constant: -10).isActive = true
        
        trialPriceInfoLabel.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor).isActive = true
        trialPriceInfoLabel.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor).isActive = true
        trialPriceInfoLabel.bottomAnchor.constraint(equalTo: cancelInfoLabel.topAnchor, constant: -10).isActive = true
        
        cancelInfoLabel.bottomAnchor.constraint(equalTo: trialView.topAnchor, constant: -15).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        //cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
        
        trialView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        trialView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        trialView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        trialView.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -10).isActive = true
        
        viewStack.leftAnchor.constraint(equalTo: trialView.leftAnchor, constant: 20).isActive = true
        viewStack.topAnchor.constraint(equalTo: trialView.topAnchor, constant: 5).isActive = true
        viewStack.bottomAnchor.constraint(equalTo: trialView.bottomAnchor, constant: -10).isActive = true
        viewStack.centerYAnchor.constraint(equalTo: trialView.centerYAnchor).isActive = true
        
        switchButton.rightAnchor.constraint(equalTo: trialView.rightAnchor, constant: -20).isActive = true
        switchButton.centerYAnchor.constraint(equalTo: trialView.centerYAnchor).isActive = true
        
        if designModel.subscribeButtons.first?.animation == "" {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        purchaseButton.topAnchor.constraint(equalTo: trialView.bottomAnchor, constant: 10).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true
        
        if designModel.subscribeButtons[1].animation == "" {
            trialPurchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            trialPurchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        } else {
            trialPurchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
            trialPurchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        }
        trialPurchaseButton.topAnchor.constraint(equalTo: trialView.bottomAnchor, constant: 10).isActive = true
        trialPurchaseButton.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
        trialPurchaseButton.heightAnchor.constraint(equalTo: purchaseButton.heightAnchor).isActive = true
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.priceInfoLabel.isHidden = true
            self.trialPriceInfoLabel.isHidden = false
            self.trialPurchaseButton.isHidden = false
            self.cancelInfoLabel.isHidden = false
        } else {
            self.priceInfoLabel.isHidden = false
            self.trialPriceInfoLabel.isHidden = true
            self.trialPurchaseButton.isHidden = true
            self.cancelInfoLabel.isHidden = true
        }
    }
    
    func setSwitchDefaultsValues() {
        self.switchButton.isOn = false
        self.trialPurchaseButton.isHidden = true
        self.trialPriceInfoLabel.isHidden = true
        self.cancelInfoLabel.isHidden = true
        
        self.switchButton.tintColor = designModel.trialView.getSwitchOffColor()
        self.switchButton.backgroundColor = designModel.trialView.getSwitchOffColor()
        self.switchButton.layer.cornerRadius = 16.0
        self.switchButton.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        self.switchButton.onTintColor = designModel.trialView.getSwitchColor()
        self.switchButton.thumbTintColor = designModel.trialView.getThumbColor()
        self.switchButton.setNeedsDisplay()

    }

}
private extension MarmarisPaywallViewController {
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButtonMarmaris(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
    
    func makeTrialPurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButtonMarmaris(model: designModel.subscribeButtons[1])
        button.addTarget(self, action: #selector(didTrialPurchaseButtonTap), for: .touchUpInside)
        return button
    }
    func makeTrialView() -> UIView {
        let view = UIFactory.makeMarmarisUIView(model: designModel.trialView)
        return view
    }
}

// MARK: - UI Actions
private extension MarmarisPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
    @objc
    func didTrialPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons[1].productId)
    }
}
