//
//  HorizontalCollectionCell.swift
//  BluetoothScanner
//
//  Created by Talha on 31.01.2024.
//

import UIKit
import Kingfisher

class HorizontalCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "HorizontalCollectionCell"

    // Container view
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Image view
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // Label
    let label: AttributedLabel = {
        let label = AttributedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
    }

    private func setupViews() {
        // Add containerView to cell's content view
        self.backgroundColor = .clear
        containerView.layer.cornerRadius = 13
        imageView.layer.cornerRadius = 13
        contentView.addSubview(containerView)

        // Constrain containerView to fill the entire cell
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        // Add imageView to containerView
        containerView.addSubview(imageView)

        // Constrain imageView to fill the entire containerView
        imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        // Add label to containerView
        containerView.addSubview(label)

        // Constrain label to the bottom left of containerView
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
    }

    // Configure cell with image and label
    public func setup(at slide: ListElementModel) {
        label.set(text: slide.text, attributeList: slide.attributes)
        if let url = URL(string: slide.image) {
            imageView.kf.setImage(with: url)
        }
    }
}
