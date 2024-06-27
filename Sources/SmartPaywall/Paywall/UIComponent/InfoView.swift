//
//  InfoView.swift
//  BluetoothScanner
//
//  Created by Talha on 30.01.2024.
//

import UIKit
import Kingfisher

final class BursaCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    
    private lazy var containerView: UIView = {
      let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .yellow
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    lazy var clientTitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

extension BursaCollectionViewCell {
    
    // MARK: - Public Methods
    
    public func setup(at slide: ListImageTextModel) {
        titleLabel.set(text: slide.subtitle.text, attributeList: slide.subtitle.attributes)
        clientTitleLabel.set(text: slide.title.text, attributeList: slide.title.attributes)
        if let url = URL(string: slide.image) {
            imageView.kf.setImage(with: url)
        }
    }
    
    // MARK: - Private Method
    
    private func commonInit() {
        contentView.backgroundColor = .clear
      
        //addSubview(commonStackView)
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(clientTitleLabel)
        
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        clientTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        
        clientTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        clientTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        clientTitleLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 5).isActive = true
        clientTitleLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.35).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.2).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: clientTitleLabel.bottomAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: clientTitleLabel.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15).isActive = true
        clientTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
