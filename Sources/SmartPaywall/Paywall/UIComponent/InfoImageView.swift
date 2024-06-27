//
//  InfoImageView.swift
//  BluetoothScanner
//
//  Created by Talha on 26.06.2023.
//

import UIKit
import Kingfisher

final class InfoImageView: UIStackView {
    private let itemSpacing: CGFloat = 50.0
    
    init(infoList: [ListImageModel]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = itemSpacing
        
        for infoModel in infoList {
            let infoSingleView = InfoImageSingleView(infoModel: infoModel)
            self.addArrangedSubview(infoSingleView)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class InfoImageSingleView: UIStackView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    init(infoModel: ListImageModel) {
        super.init(frame: .zero)
        self.setupUI()
        if let url = URL(string: infoModel.image) {
            imageView.kf.setImage(with: url)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        self.axis = .vertical
        self.spacing = 50
        
        self.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
