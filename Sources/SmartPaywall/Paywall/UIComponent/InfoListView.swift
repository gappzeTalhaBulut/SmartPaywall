//
//  InfoListView.swift
//  blocker
//
//  Created by Talip on 9.04.2023.
//

import UIKit
import Kingfisher

final class InfoListView: UIStackView {
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

final class InfoSingleView: UIStackView {
    private var infoModel: ListElementModel
    
    private lazy var infoItemView: InfoItemView = {
        let itemView = InfoItemView(infoModel: infoModel)
        return itemView
    }()
    
    init(infoModel: ListElementModel) {
        self.infoModel = infoModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        self.axis = .horizontal
        self.spacing = 5
        self.addArrangedSubview(infoItemView)
        NSLayoutConstraint.activate([
            infoItemView.topAnchor.constraint(equalTo: self.topAnchor),
            infoItemView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            infoItemView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoItemView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}






