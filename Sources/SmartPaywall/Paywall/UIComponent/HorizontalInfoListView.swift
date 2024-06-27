//
//  HorizontalInfoListView.swift
//  BluetoothScanner
//
//  Created by Talha on 21.06.2023.
//

import UIKit
import Kingfisher

final class HorizontalInfoListView: UIStackView {
    private let itemSpacing: CGFloat = 10.0
    
    init(infoList: [ListElementModel]) {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.spacing = itemSpacing
        
        for infoModel in infoList {
            let infoSingleView = InfoView(infoModel: infoModel)
            self.addArrangedSubview(infoSingleView)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class InfoView: UIStackView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var infoHorizontalLabel: AttributedLabel = {
        let label = AttributedLabel()
        return label
    }()
    
    init(infoModel: ListElementModel) {
        super.init(frame: .zero)
        self.setupUI()
        infoHorizontalLabel.set(text: infoModel.text, attributeList: infoModel.attributes)
        if let url = URL(string: infoModel.image) {
            imageView.kf.setImage(with: url)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        self.axis = .horizontal
        self.spacing = 5
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(infoHorizontalLabel)
    }
}






