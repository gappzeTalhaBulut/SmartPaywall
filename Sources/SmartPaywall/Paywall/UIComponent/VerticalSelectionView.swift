//
//  VerticalSelectionView.swift
//  BluetoothScanner
//
//  Created by Talha on 24.01.2024.
//

import UIKit
import Kingfisher
import BaseFoundation

final class VerticalSelectionView: UITableView, UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withClass: ProductCell.self, for: indexPath)
        let price = priceList[model.productList[indexPath.row].productId]?.localizedPrice ?? ""
        cell.configure(with: model.productList[indexPath.row],
                       backgroundColor: model.backgroundColor,
                       unSelectedImage: model.unSelectedImage ?? "",
                       selectedImage: model.selectedImage ?? "",
                       selectedColor: model.selectedColor,
                       priceValue: price,
                       ticketValue: model.productList[indexPath.row].ticketValue)
        
        if model.productList[indexPath.row].ticketValue == "" {
               cell.paddingView.isHidden = true
               cell.trialLabel.isHidden = true
           } else {
               cell.paddingView.isHidden = false
               cell.trialLabel.isHidden = false
           }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102 + (10 * CGFloat(UIScreen.main.scale))
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

private extension VerticalSelectionView {
    func setupUI() {
        backgroundColor = .clear
        separatorStyle = .none
        backgroundColor = .clear
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        footerView.backgroundColor = .clear // İstediğiniz arkaplan rengini belirleyin

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: footerView.frame.width, height: 30))
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        footerView.addSubview(label)

        tableFooterView = footerView
    
        register(ProductCell.self)
        delegate = self
        dataSource = self
        reloadData()
        contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

final class ProductCell: UITableViewCell {
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
        label.textColor = UIColor(hex: "24525B")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = label.font.withSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "F37F3C")
        view.layer.cornerRadius = 9
        return view
    }()
    
    lazy var trialLabel: UILabel = {
       let label = UILabel()
       label.textAlignment = .center
       label.textColor = .white
        label.text = "Most Popular"
       label.font = label.font.withSize(13)
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
                   ticketValue: String) {
        let selectedColor = UIColor(hex: selectedColor)
        containerView.backgroundColor = UIColor(hex: backgroundColor)
        if let url = URL(string: product.isSelected ? selectedImage : unSelectedImage) {
            leftImageView.kf.setImage(with: url)
        }
        titleLabel.text = product.productName
        subTitleLabel.text = product.subText
        trialLabel.text = product.ticketValue
        subTitleLabel.isHidden = product.subText.isEmpty
        priceLabel.text = priceValue
        let unSelectedColor = UIColor.lightGray
        containerView.layer.borderWidth = product.isSelected ? 2.0 : 0.8
        containerView.layer.borderColor = product.isSelected ? selectedColor.cgColor : unSelectedColor.cgColor
        titleLabel.textColor = product.isSelected ? selectedColor : unSelectedColor
        
        selectionStyle = .none
    }
}

private extension ProductCell {
    func setupUI() {
        backgroundColor = .clear
        addSubview(containerView)
        containerView.addSubview(leftImageView)
        containerView.addSubview(titleStackView)
        containerView.addSubview(priceLabel)
        addSubview(paddingView)
        addSubview(trialLabel)
        paddingView.addSubview(trialLabel)
        bringSubviewToFront(paddingView)
        //bringSubviewToFront(trialLabel)
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -18).isActive = true
        
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
        
        trialLabel.leadingAnchor.constraint(equalTo: paddingView.leadingAnchor, constant: 5).isActive = true
        trialLabel.trailingAnchor.constraint(equalTo: paddingView.trailingAnchor, constant: -5).isActive = true
        trialLabel.topAnchor.constraint(equalTo: paddingView.topAnchor, constant: 5).isActive = true
        trialLabel.bottomAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: -5).isActive = true
        
        paddingView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -10).isActive = true
        paddingView.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor).isActive = true
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)
        
        containerView.layer.cornerRadius = 8
        selectionStyle = .none
    }
}
