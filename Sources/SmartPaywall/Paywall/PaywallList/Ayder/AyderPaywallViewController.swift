//
//  AyderPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 31.01.2024.
//

import UIKit

final class AyderPaywallViewController: BasePaywallController {
    
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var trialInfoLabel = UIFactory.makeLabel(model: designModel.trialInfo)
    private lazy var priceInfoLabel = UIFactory.makeCalculatedLabel(model: designModel.priceInfo,
                                                               priceList: self.priceList)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    
    private lazy var dataCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false

        // Register your custom cell class
        collection.register(HorizontalCollectionCell.self, forCellWithReuseIdentifier: HorizontalCollectionCell.reuseIdentifier)

        // Add any additional configuration here...

        return collection
    }()

    
    private let designModel: AyderModel
    
    init(designModel: AyderModel,
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
        self.dataCollection.register(HorizontalCollectionCell.self)
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(dataCollection)
        view.addSubview(trialInfoLabel)
        view.addSubview(priceInfoLabel)
        view.addSubview(purchaseButton)
        view.addSubview(cancelInfoLabel)
        view.addSubview(titleLabel)
 
        
        
        dataCollection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dataCollection.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dataCollection.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.14).isActive = true
        dataCollection.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: dataCollection.bottomAnchor, constant: 45).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        trialInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        trialInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        trialInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        trialInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        priceInfoLabel.leadingAnchor.constraint(equalTo: trialInfoLabel.leadingAnchor).isActive = true
        priceInfoLabel.trailingAnchor.constraint(equalTo: trialInfoLabel.trailingAnchor).isActive = true
       // priceInfoLabel.topAnchor.constraint(equalTo: trialInfoLabel.bottomAnchor, constant: 10).isActive = true
        priceInfoLabel.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -15).isActive = true
        priceInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true

        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
}



extension AyderPaywallViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.designModel.sliderInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: HorizontalCollectionCell.self,
                                                      for: indexPath)
        let items = self.designModel.sliderInfo[indexPath.item]
        cell.setup(at: items)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 2.8
        let height: CGFloat = self.view.frame.height * 0.12
        return CGSize(width: width, height: height)
    }
}
private extension AyderPaywallViewController {
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}

// MARK: - UI Actions
private extension AyderPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}

