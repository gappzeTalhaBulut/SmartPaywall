//
//  VerticalProductSelectionView.swift
//  BluetoothScanner
//
//  Created by Talip on 6.07.2023.
//

import UIKit
import Kingfisher
import BaseFoundation

final class VerticalProductSelectionView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var didSelect: ((_ productId: String) -> ())?

    private var model: SubscriptionOptionModel
    private let priceList: PriceList
    
    init(model: SubscriptionOptionModel,
         priceList: PriceList) {
        self.model = model
        self.priceList = priceList
        super.init(frame: .zero, style: .plain)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ProductSelectionCell.self, for: indexPath)
        
        let product = model.productList[indexPath.row]
        let price = priceList[product.productId]?.localizedPrice ?? ""
        
        let divisionFactor = product.multiplier
        let divisionFactor2 = product.multiplier2
        
        var dividedPriceString = product.subText.replacePrice(with: priceList, multiplier: 1 / divisionFactor)
        dividedPriceString = dividedPriceString.replacePrice(with: priceList, multiplier: 1 / divisionFactor2)
        // attributeList'i uygun şekilde oluşturun
        let attributeList = model.textAttributes
        
        cell.configure(with: product,
                       backgroundColor: model.backgroundColor,
                       unSelectedImage: model.unSelectedImage ?? "",
                       selectedImage: model.selectedImage ?? "",
                       selectedColor: model.selectedColor,
                       priceValue: price,
                       subText: dividedPriceString,
                       attributeList: attributeList)
        
        return cell
    }

/*
 label.textAlignment = model.textAlignment.convert()
 var priceFormattedString = model.text.replacePrice(with: priceList, multiplier: 1 / (model.multiplier ?? 1.0))
 priceFormattedString = priceFormattedString.replacePrice(with: priceList, multiplier: 1 / (model.multiplier2 ?? 1.0)) */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42 + (10 * CGFloat(UIScreen.main.scale))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var productList: [SubscriptionProductModel] = []
        var selectedProductId = ""
        
        for var (index, product) in model.productList.enumerated() {
            if index == indexPath.row {
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

private extension VerticalProductSelectionView {
    func setupUI() {
        backgroundColor = .clear
        
        separatorStyle = .none
        backgroundColor = .clear
    
        register(ProductSelectionCell.self)
        delegate = self
        dataSource = self
        reloadData()
    }
}

final class ProductSelectionCell: UITableViewCell {
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var leftImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(16)
        return label
    }()
    
    private lazy var subTitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: "0F61F8")
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with product: SubscriptionProductModel,
                   backgroundColor: String,
                   unSelectedImage: String,
                   selectedImage: String,
                   selectedColor: String,
                   priceValue: String,
                   subText: String,
                   attributeList: [TextAttributeModel]) {
        let selectedColor = UIColor(hex: selectedColor)
        containerView.backgroundColor = UIColor(hex: backgroundColor)
        if let url = URL(string: product.isSelected ? selectedImage : unSelectedImage) {
            leftImageView.kf.setImage(with: url)
        }
        titleLabel.text = product.productName
        subTitleLabel.set(text: subText, attributeList: attributeList)
        subTitleLabel.isHidden = product.subText.isEmpty
        priceLabel.text = priceValue
        containerView.layer.borderWidth = product.isSelected ? 2.0 : 0
        containerView.layer.borderColor = product.isSelected ? selectedColor.cgColor : .none
        selectionStyle = .none
    }
}

private extension ProductSelectionCell {
    func setupUI() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(leftImageView)
        containerView.addSubview(titleStackView)
        containerView.addSubview(priceLabel)
        
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        leftImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        leftImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17.5).isActive = true
        leftImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -17.5).isActive = true
        leftImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        leftImageView.heightAnchor.constraint(equalTo: leftImageView.widthAnchor).isActive = true
        
        titleStackView.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 15).isActive = true
        titleStackView.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor).isActive = true
        titleStackView.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -15).isActive = true
        
        priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: leftImageView.centerYAnchor).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        
        containerView.layer.cornerRadius = 15
        selectionStyle = .none
    }
}
