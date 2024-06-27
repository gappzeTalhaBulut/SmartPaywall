//
//  SubscriptionButtonModel.swift
//  MeditationApp
//
//  Created by Talip on 25.04.2023.
//

import UIKit

struct SubscriptionButtonModel: Decodable {
    let text: String
    let backgroundColor: String
    let productId: String
    let borderColor: String?
    let borderWidth: CGFloat?
    let animation: String?
    let heightAnchor: CGFloat?
    let attributes: [TextAttributeModel]
    
    private enum CodingKeys: String, CodingKey {
        case text
        case backgroundColor
        case productId
        case borderColor
        case borderWidth
        case animation
        case attributes
        case heightAnchor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId) ?? ""
        self.borderColor = try container.decodeIfPresent(String.self, forKey: .borderColor)
        self.borderWidth = try container.decodeIfPresent(CGFloat.self, forKey: .borderWidth)
        self.animation = try container.decodeIfPresent(String.self, forKey: .animation)
        self.attributes = try container.decode([TextAttributeModel].self, forKey: .attributes)
        self.heightAnchor = try container.decodeIfPresent(CGFloat.self, forKey: .heightAnchor)
    }
    
}

extension SubscriptionButtonModel {
    func getBorderWidth() -> CGFloat {
        if let borderWidth = borderWidth {
            return borderWidth
        } else {
            return 0
        }
    }
    func getHeightAnchor() -> CGFloat {
        if let heightAnchor = heightAnchor {
            return heightAnchor
        } else {
            return 62
        }
    }
    func getBorderColor() -> CGColor? {
        if let borderColor = borderColor {
            return UIColor(hex: borderColor).cgColor
        } else {
            return nil
        }
    }
    
}

