//
//  ListImageTextModel.swift
//  BluetoothScanner
//
//  Created by Talha on 2.02.2024.
//

import Foundation

struct ListImageTextModel: Decodable {
    let image: String
    struct ItemModel: Decodable {
        let text: String
        let attributes: [TextAttributeModel]
    }
    let title: ItemModel
    let subtitle: ItemModel
}
