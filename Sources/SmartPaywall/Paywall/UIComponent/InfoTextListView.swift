//
//  InfoTextListView.swift
//  BluetoothScanner
//
//  Created by Talha on 23.06.2023.
//

import UIKit
import Kingfisher

final class InfoTextListView: UIStackView {
    private let itemSpacing: CGFloat = 40.0
    
    init(infoList: [ListImageTextModel]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = itemSpacing
        
        for infoModel in infoList {
            let infoSingleView = InfoTextSingleView(infoModel: infoModel)
            self.addArrangedSubview(infoSingleView)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class InfoTextSingleView: UIStackView {
    private lazy var titleLabel: AttributedLabel = {
        let label = AttributedLabel()
        return label
    }()
    
    private lazy var subtitleLabel: AttributedLabel = {
        let label = AttributedLabel()
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(infoModel: ListImageTextModel) {
        super.init(frame: .zero)
        self.setupUI()
        titleLabel.set(text: infoModel.title.text, attributeList: infoModel.title.attributes)
        subtitleLabel.set(text: infoModel.subtitle.text, attributeList: infoModel.subtitle.attributes)
        if let url = URL(string: infoModel.image) {
            imageView.kf.setImage(with: url)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .fill
        self.spacing = 10
        
        // Add the image view to the left side
        self.addArrangedSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 5
        
        self.addArrangedSubview(textStackView)
        
        // You can adjust the constraints based on your layout requirements
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: self.topAnchor),
            textStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            textStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
