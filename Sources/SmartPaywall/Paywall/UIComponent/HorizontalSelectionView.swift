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
        
        if model.productList[indexPath.item].ticketValue == "" {
            cell.ticketView.isHidden = true
            cell.ticketLabel.isHidden = true
        } else {
            cell.ticketView.isHidden = false
            cell.ticketLabel.isHidden = false
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.frame.width - 20
        let selectedWidth: CGFloat = (totalWidth / 3) + 20 // Seçili hücre genişliği
        let unselectedWidth: CGFloat = (totalWidth - selectedWidth) / 2 // Diğer hücrelerin genişliği
        
        let isSelected = model.productList[indexPath.item].isSelected
        
        // Seçili hücre genişliği 20 piksel artacak, diğerleri küçülecek
        let width = isSelected ? selectedWidth : unselectedWidth
        let height: CGFloat = isSelected ? 150 : 130
        
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
    
    lazy var ticketView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var ticketLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
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
        ticketView.backgroundColor = selectedColor
        ticketLabel.text = product.ticketValue
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
        
        containerView.layer.zPosition = 0
        ticketView.layer.zPosition = 1
        
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(titleStackView)
        containerView.addSubview(ticketView)
        ticketView.addSubview(ticketLabel)
    
        titleStackView.addArrangedSubview(priceLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        bringSubviewToFront(ticketView)
        
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
            titleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            ticketLabel.topAnchor.constraint(equalTo: ticketView.topAnchor, constant: 2),
            ticketLabel.leadingAnchor.constraint(equalTo: ticketView.leadingAnchor, constant: 10),
            ticketLabel.trailingAnchor.constraint(equalTo: ticketView.trailingAnchor, constant: -10),
            ticketLabel.bottomAnchor.constraint(equalTo: ticketView.bottomAnchor, constant: -2),
            
            ticketView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -10),
            ticketView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
