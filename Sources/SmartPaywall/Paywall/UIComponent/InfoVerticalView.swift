//
//  InfoVerticalView.swift
//  BluetoothScanner
//
//  Created by Talha on 30.01.2024.
//

import UIKit
import Kingfisher

final class InfoVerticalView: UIStackView {
    private let itemSpacing: CGFloat = 7.5
    
    init(infoList: [ListElementModel]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = itemSpacing
        
        for infoModel in infoList {
            let infoSingleView = InfoSingleView(infoModel: infoModel)
            self.addArrangedSubview(infoSingleView)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class InfoSıngleVerticalView: UIStackView {
    private var infoModel: ListElementModel
    
    private lazy var infoItemView: InfoSıngleItemView = {
        let itemView = InfoSıngleItemView(infoModel: infoModel)
        return itemView
    }()
    
    init(infoModel: ListElementModel) {
        self.infoModel = infoModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        self.axis = .vertical // Change the axis to vertical
        self.spacing = 5
        self.addArrangedSubview(infoItemView)
    }
}

final class InfoSıngleItemView: UIView {
    private var infoModel: ListElementModel
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: infoModel.image))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = infoModel.text
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(infoModel: ListElementModel) {
        self.infoModel = infoModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
