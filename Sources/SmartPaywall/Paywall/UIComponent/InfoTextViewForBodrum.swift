//
//  InfoTextViewForBodrum.swift
//  BluetoothScanner
//
//  Created by Talha on 9.08.2023.
//

import UIKit

import UIKit

final class InfoTextListViewForBodrum: UIStackView {
    private let itemSpacing: CGFloat = 10
    
    init(infoList: [ListTextModel]) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.alignment = .fill
        self.spacing = itemSpacing
        
        for infoModel in infoList {
            let infoSingleView = InfoTextSingleViewForBodrum(infoModel: infoModel)
            self.addArrangedSubview(infoSingleView)
        }
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class InfoTextSingleViewForBodrum: UIStackView {
    private var infoModel: ListTextModel
    
    private lazy var infoItemView: InfoTextItemView = {
        let itemView = InfoTextItemView(infoModel: infoModel)
        return itemView
    }()
    
    init(infoModel: ListTextModel) {
        self.infoModel = infoModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        self.axis = .vertical
        self.spacing = 0
        //self.distribution = .equalSpacing
        self.alignment = .fill
        self.distribution = .fillEqually
        self.addArrangedSubview(infoItemView)
        
        NSLayoutConstraint.activate([
            infoItemView.topAnchor.constraint(equalTo: self.topAnchor),
            infoItemView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoItemView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            infoItemView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
