//
//  File.swift
//  
//
//  Created by Talha on 11.10.2024.
//

import UIKit
import Kingfisher
import BaseFoundation

final class VerticalProductSelectionViewAkdeniz: UITableView, UITableViewDelegate, UITableViewDataSource {
    var didSelect: ((_ productId: String) -> ())?

    private var model: SubscriptionOptionMultiplierModel
    private let priceList: PriceList
    
    init(model: SubscriptionOptionMultiplierModel,
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
        let cell = tableView.dequeueReusableCell(withClass: ProductSelectionCellAkdeniz.self, for: indexPath)
        
        let product = model.productList[indexPath.row]
        
        let divisionFactor = product.multiplier ?? 1.0
        let divisionFactor2 = product.multiplier2 ?? 1.0
        
        var dividedPriceString = product.subText.replacePrice(with: priceList, multiplier: 1 / divisionFactor)
        dividedPriceString = dividedPriceString.replacePrice(with: priceList, multiplier: 1 / divisionFactor2)
        // attributeList'i uygun şekilde oluşturun
        let attributeList = model.textAttributes ?? []
        
        cell.configure(with: product,
                       backgroundColor: model.backgroundColor,
                       selectedColor: model.selectedColor,
                       priceValue: dividedPriceString,
                       ticketText: product.ticketValue,
                       attributeList: attributeList)
        
        if product.ticketValue == "" {
            cell.ticketView.isHidden = true
            cell.ticketLabel.isHidden = true
        } else {
            cell.ticketView.isHidden = false
            cell.ticketLabel.isHidden = false
        }
        
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
        var productList: [SubscriptionMultiplierProductModel] = []
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

private extension VerticalProductSelectionViewAkdeniz {
    func setupUI() {
        backgroundColor = .clear
        
        separatorStyle = .none
        backgroundColor = .clear
    
        register(ProductSelectionCellAkdeniz.self)
        delegate = self
        dataSource = self
        reloadData()
    }
}

final class ProductSelectionCellAkdeniz: UITableViewCell {
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var priceLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 9
        view.backgroundColor = UIColor(hex: "#99E4AC")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var ticketLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: "#00440C")
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
    
    func configure(with product: SubscriptionMultiplierProductModel,
                   backgroundColor: String,
                   selectedColor: String,
                   priceValue: String,
                   ticketText: String,
                   attributeList: [TextAttributeModel]) {
        let selectedColor = UIColor(hex: selectedColor)
        containerView.backgroundColor = UIColor(hex: backgroundColor)
        priceLabel.set(text: priceValue, attributeList: attributeList)
        ticketLabel.text = ticketText
        containerView.layer.borderWidth = product.isSelected ? 1.0 : 0
        containerView.layer.borderColor = product.isSelected ? selectedColor.cgColor : UIColor(hex: "#DDDDDF").cgColor
        selectionStyle = .none
    }
}

private extension ProductSelectionCellAkdeniz {
    func setupUI() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(ticketView)
        ticketView.addSubview(ticketLabel)
        
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    
        priceLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: ticketView.leadingAnchor, constant: -10).isActive = true
        
        ticketLabel.topAnchor.constraint(equalTo: ticketView.topAnchor, constant: 5).isActive = true
        ticketLabel.bottomAnchor.constraint(equalTo: ticketView.bottomAnchor, constant: -5).isActive = true
        ticketLabel.leadingAnchor.constraint(equalTo: ticketView.leadingAnchor, constant: 10).isActive = true
        ticketLabel.trailingAnchor.constraint(equalTo: ticketView.trailingAnchor, constant: -10).isActive = true
        
        ticketView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        ticketView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        containerView.layer.cornerRadius = 15
        selectionStyle = .none
    }
}

