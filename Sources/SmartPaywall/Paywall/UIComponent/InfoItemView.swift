//
//  InfoItemView.swift
//  BluetoothScanner
//
//  Created by Talha on 29.07.2023.
//

import UIKit

class InfoItemView: UIView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var infoLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        return label
    }()

    init(infoModel: ListElementModel) {
        super.init(frame: .zero)
        setupUI()
        infoLabel.set(text: infoModel.text, attributeList: infoModel.attributes)
        if let url = URL(string: infoModel.image) {
            imageView.kf.setImage(with: url)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(imageView)
        addSubview(infoLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20),

            infoLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5),
            infoLabel.topAnchor.constraint(equalTo: topAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }
}

