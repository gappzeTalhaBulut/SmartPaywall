//
//  GridInfoListView.swift
//  BluetoothScanner
//
//  Created by Talha on 30.06.2023.
//

import UIKit
import Kingfisher

final class GridInfoListView: UIStackView {
    private let itemSpacing: CGFloat = 10.0
    private let columnCount: Int = 2

    init(infoList: [ListElementModel]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = itemSpacing

        for i in 0..<infoList.count {
            if i % columnCount == 0 {
                let rowStackView = UIStackView()
                rowStackView.axis = .horizontal
                rowStackView.spacing = itemSpacing
                rowStackView.alignment = .fill
                rowStackView.distribution = .fillEqually
                self.addArrangedSubview(rowStackView)
            }

            let infoSingleView = GridInfoSingleView(infoModel: infoList[i])
            (self.arrangedSubviews[i / columnCount] as? UIStackView)?.addArrangedSubview(infoSingleView)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class GridInfoSingleView: UIStackView {
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()

    private lazy var infoLabel: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    init(infoModel: ListElementModel) {
        super.init(frame: .zero)
        self.setupUI()
        infoLabel.set(text: infoModel.text, attributeList: infoModel.attributes)
        if let url = URL(string: infoModel.image) {
            imageView.kf.setImage(with: url)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.axis = .vertical
        self.spacing = 5

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(infoLabel)
    }
}
