//
//  HorizontalListCell.swift
//  BluetoothScanner
//
//  Created by Talha on 31.01.2024.
//

import UIKit

class HorizontalListCell: UITableViewCell {
    
    static let reuseIdentifier = "HorizontalListCell"
    
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Text label on the left
    let textLabelLeft: AttributedLabel = {
        let label = AttributedLabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let freeText: UILabel = {
        let label = UILabel()
        label.text = "Free"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let proText: UILabel = {
        let label = UILabel()
        label.text = "Pro"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let freeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let proImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var imageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 28
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
       
    }
    private func setupViews() {
        //containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 13
        contentView.addSubview(containerView)
        containerView.addSubview(textLabelLeft)
        containerView.addSubview(imageStackView)
        containerView.addSubview(freeText)
        containerView.addSubview(proText)
        
        imageStackView.addArrangedSubview(freeImageView)
        imageStackView.addArrangedSubview(proImageView)
        
       
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true

        textLabelLeft.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        textLabelLeft.trailingAnchor.constraint(equalTo: imageStackView.leadingAnchor, constant: -10).isActive = true
        textLabelLeft.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
       
        freeText.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -15).isActive = true
        freeText.trailingAnchor.constraint(equalTo: proText.leadingAnchor, constant: -20).isActive = true
        
        proText.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -15).isActive = true
        proText.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15).isActive = true
        
        imageStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18).isActive = true
        
        freeImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        freeImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true

        proImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        proImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }

    public func setup(at slide: ListElementModel) {
        textLabelLeft.set(text: slide.text, attributeList: slide.attributes)
        if let url = URL(string: slide.image) {
            freeImageView.kf.setImage(with: url)
        }
        if let url = URL(string: slide.image2 ?? "") {
            proImageView.kf.setImage(with: url)
        }
    }
}
