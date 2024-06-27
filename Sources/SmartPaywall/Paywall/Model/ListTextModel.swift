//
//  ListTextModel.swift
//  BluetoothScanner
//
//  Created by Talha on 23.06.2023.
//

import Foundation

struct ListTextModel: Decodable {
    struct TextModel: Decodable {
        let text: String
        let attributes: [TextAttributeModel]
    }
    let title: TextModel
    let subtitle: TextModel
}

