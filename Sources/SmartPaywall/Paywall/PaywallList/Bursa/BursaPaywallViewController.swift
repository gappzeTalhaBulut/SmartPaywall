//
//  BursaPaywallViewController.swift
//  BluetoothScanner
//
//  Created by Talha on 30.01.2024.
//

import UIKit

final class BursaPaywallViewController: BasePaywallController {
    private lazy var titleLabel = UIFactory.makeLabel(model: designModel.title)
    private lazy var priceDescription = UIFactory.makeCalculatedLabel(model: designModel.description,
                                                               priceList: self.priceList)
    private lazy var purchaseButton = makePurchaseButton()
    private lazy var cancelInfoLabel = UIFactory.makeLabel(model: designModel.cancelInfo)
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = self.designModel.sliderInfo.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor(hex: designModel.pageDots.active)
        pageControl.pageIndicatorTintColor = UIColor(hex: designModel.pageDots.inactive)
        return pageControl
    }()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = true
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var currentPage: Int = 0 {
        didSet {
            self.pageControl.currentPage = currentPage
            if currentPage == self.designModel.sliderInfo.count - 1 {
                print("son")
            } else {
                print(currentPage)
            }
        }
    }
    private let designModel: BursaModel
    
    init(designModel: BursaModel,
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
        self.collectionView.register(BursaCollectionViewCell.self)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.currentPage = 0
       
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(titleLabel)
        view.addSubview(purchaseButton)
        view.addSubview(priceDescription)
        view.addSubview(cancelInfoLabel)
        view.addSubview(collectionView)
        view.addSubview(pageControl)

        titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: priceDescription.widthAnchor, multiplier: 0.8).isActive = true

        priceDescription.widthAnchor.constraint(equalTo: collectionView.widthAnchor).isActive = true
        priceDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        priceDescription.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.topAnchor.constraint(equalTo: priceDescription.bottomAnchor, constant: 10).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.18).isActive = true
        
        pageControl.heightAnchor.constraint(equalToConstant: 35).isActive = true
        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        purchaseButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 10).isActive = true
        purchaseButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        purchaseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        purchaseButton.heightAnchor.constraint(equalToConstant: designModel.subscribeButtons.first?.getHeightAnchor() ?? 62).isActive = true

        cancelInfoLabel.topAnchor.constraint(equalTo: purchaseButton.bottomAnchor, constant: 25).isActive = true
        cancelInfoLabel.centerXAnchor.constraint(equalTo: purchaseButton.centerXAnchor).isActive = true
        cancelInfoLabel.bottomAnchor.constraint(equalTo: restoreLabel.topAnchor, constant: -25).isActive = true
    }
}

private extension BursaPaywallViewController {
    func makePurchaseButton() -> UIButton {
        let button = UIFactory.makePurchaseButton(model: designModel.subscribeButtons.first)
        button.addTarget(self, action: #selector(didPurchaseButtonTap), for: .touchUpInside)
        return button
    }
}

// MARK: - UI Actions
private extension BursaPaywallViewController {
    @objc
    func didPurchaseButtonTap() {
        self.onPurchase?(designModel.subscribeButtons.first?.productId ?? "")
    }
}
extension BursaPaywallViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: BursaCollectionViewCell.self,
                                                      for: indexPath)
        let items = self.designModel.sliderInfo[indexPath.item]
        cell.setup(at: items)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        self.designModel.sliderInfo.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -

extension BursaPaywallViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            self.currentPage = indexPath.item
        }
    }

}
