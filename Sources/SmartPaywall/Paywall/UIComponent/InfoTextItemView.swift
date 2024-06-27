//
//  InfoTextItemView.swift
//  BluetoothScanner
//
//  Created by Talha on 9.08.2023.
//

import UIKit

class InfoTextItemView: UIView {
    private lazy var label: AttributedLabel = {
        let label = AttributedLabel()
        label.numberOfLines = 0
        return label
    }()

    private lazy var sublabel: AttributedLabel = {
        let label = AttributedLabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    init(infoModel: ListTextModel) {
        super.init(frame: .zero)
        setupUI()
        label.set(text: infoModel.title.text, attributeList: infoModel.title.attributes)
        sublabel.set(text: infoModel.subtitle.text, attributeList: infoModel.subtitle.attributes)
        sublabel.setContentCompressionResistancePriority(.required, for: .vertical)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(label)
        addSubview(sublabel)

        label.translatesAutoresizingMaskIntoConstraints = false
        sublabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            sublabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            sublabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sublabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sublabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
