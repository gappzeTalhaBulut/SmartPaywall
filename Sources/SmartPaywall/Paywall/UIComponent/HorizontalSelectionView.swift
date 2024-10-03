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

    private var model: SubscriptionOptionModel
    private var priceList: PriceList
    private let cellIdentifier = "ProductSelectionCell"

    init(model: SubscriptionOptionModel, priceList: PriceList) {
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
        let width = (collectionView.frame.width - 20) / 3 // 3 items in a row with 10pt spacing
        let height: CGFloat = 130 // You can adjust this based on your content
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var productList: [SubscriptionProductModel] = []
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
        reloadData()
        didSelect?(selectedProductId)
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
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(16)
        return label
    }()

    private lazy var subTitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
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

    func configure(with product: SubscriptionProductModel,
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
        containerView.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        titleStackView.addArrangedSubview(priceLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            titleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            titleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        ])
    }
}
