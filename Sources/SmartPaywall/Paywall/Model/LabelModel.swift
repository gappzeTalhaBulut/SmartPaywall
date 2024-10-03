//
//  LabelModel.swift
//  BluetoothScanner
//
//  Created by Talip on 8.06.2023.
//

import Foundation

struct LabelModel: Decodable {
    let text: String
    let url: String?
    let textAlignment: TextAlignmentType
    let attributes: [TextAttributeModel]
    let multiplier: Double
    let multiplier2: Double
    let isVisible: Bool
    
    private enum CodingKeys: String, CodingKey {
        case text
        case url
        case textAlignment
        case attributes
        case isVisible
        case multiplier
        case multiplier2
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.textAlignment = try container.decodeIfPresent(TextAlignmentType.self, forKey: .textAlignment) ?? .center
        self.attributes = try container.decode([TextAttributeModel].self, forKey: .attributes)
        self.isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible) ?? true
        self.multiplier = try container.decode(Double.self, forKey: .multiplier)
        self.multiplier2 = try container.decode(Double.self, forKey: .multiplier2)
    }
}




