//
//  HorizontalSelectionView.swift
//  BluetoothScanner
//
//  Created by Talha on 29.01.2024.
//

import UIKit
import Kingfisher

final class HorizontalSelectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var didSelect: ((_ productId: String) -> ())?

    private var model: SubscriptionOptionMultiplierModel
    private var priceList: PriceList
    private let cellIdentifier = "ProductSelectionCell"

    init(model: SubscriptionOptionMultiplierModel, priceList: PriceList) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.model = model
        self.priceList = priceList
        super.init(frame: .zero, collectionViewLayout: layout)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.productList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HorizontalProductSelectionCell
        let product = model.productList[indexPath.row]
        let price = priceList[product.productId]?.localizedPrice ?? ""
        
        let divisionFactor = product.multiplier ?? 1.0
        let divisionFactor2 = product.multiplier2 ?? 1.0
        
        var dividedPriceString = product.subText.replacePrice(with: priceList, multiplier: 1 / divisionFactor)
        dividedPriceString = dividedPriceString.replacePrice(with: priceList, multiplier: 1 / divisionFactor2)
        // attributeList'i uygun şekilde oluşturun
        let attributeList = model.textAttributes ?? []
        
        cell.configure(with: model.productList[indexPath.item],
                       backgroundColor: model.backgroundColor,
                       selectedColor: model.selectedColor,
                       priceValue: price,
                       subText: dividedPriceString,
                       attributeList: attributeList)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = model.productList[indexPath.item].isSelected
        let width = (collectionView.frame.width - 20) / 3 // Varsayılan genişlik
        let height: CGFloat = isSelected ? 150 : 130 // Seçili hücre daha büyük olacak
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var productList: [SubscriptionMultiplierProductModel] = []
        var selectedProductId = ""

        for var (index, product) in model.productList.enumerated() {
            if index == indexPath.item {
                product.isSelected = true
                selectedProductId = product.productId
            } else {
                product.isSelected = false
            }

            productList.append(product)
        }

        model.productList = productList
        collectionView.performBatchUpdates {
            // Bu işlemler collectionView'in boyutları güncellenirken yapılır
            
        } completion: { _ in
            collectionView.reloadData()
            self.didSelect?(selectedProductId)
        }
    }
}

private extension HorizontalSelectionView {
    func setupUI() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        register(HorizontalProductSelectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        delegate = self
        dataSource = self
        reloadData()
    }
}

final class HorizontalProductSelectionCell: UICollectionViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    private lazy var subTitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with product: SubscriptionMultiplierProductModel,
                   backgroundColor: String,
                   selectedColor: String,
                   priceValue: String,
                   subText: String,
                   attributeList: [TextAttributeModel]) {
        let selectedColor = UIColor(hex: selectedColor)
        containerView.backgroundColor = UIColor(hex: backgroundColor)
        titleLabel.text = product.productName
        subTitleLabel.set(text: subText, attributeList: attributeList)
        subTitleLabel.isHidden = product.subText.isEmpty
        priceLabel.text = priceValue
        let unSelectedColor = UIColor.lightGray
        titleLabel.textColor = selectedColor
        containerView.layer.borderWidth = product.isSelected ? 3.0 : 0.0
        containerView.layer.borderColor = product.isSelected ? selectedColor.cgColor : unSelectedColor.cgColor
    }
}

private extension HorizontalProductSelectionCell {
    func setupUI() {
        backgroundColor = .clear
        containerView.layer.cornerRadius = 15
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleStackView)
    
        titleStackView.addArrangedSubview(priceLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            
            titleStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            titleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
    }
}
