//
//  UIViewModel.swift
//  BluetoothScanner
//
//  Created by Talha on 2.09.2023.
//

import UIKit

struct UIViewModel: Decodable {
    let text: String
    let backgroundColor: String
    let borderColor: String?
    let borderWidth: CGFloat?
    let animation: String?
    let switchColor: String?
    let thumbColor: String?
    let switchOffColor: String?
    let attributes: [TextAttributeModel]
    
    private enum CodingKeys: String, CodingKey {
        case text
        case backgroundColor
        case borderColor
        case borderWidth
        case animation
        case attributes
        case switchColor
        case thumbColor
        case switchOffColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
        self.borderColor = try container.decodeIfPresent(String.self, forKey: .borderColor)
        self.borderWidth = try container.decodeIfPresent(CGFloat.self, forKey: .borderWidth)
        self.animation = try container.decodeIfPresent(String.self, forKey: .animation)
        self.attributes = try container.decode([TextAttributeModel].self, forKey: .attributes)
        self.switchColor = try container.decodeIfPresent(String.self, forKey: .switchColor)
        self.thumbColor = try container.decodeIfPresent(String.self, forKey: .thumbColor)
        self.switchOffColor = try container.decodeIfPresent(String.self, forKey: .switchOffColor)
    }
    
}

extension UIViewModel {
    func getBorderWidth() -> CGFloat {
        if let borderWidth = borderWidth {
            return borderWidth
        } else {
            return 0
        }
    }
    func getBorderColor() -> CGColor? {
        if let borderColor = borderColor {
            return UIColor(hex: borderColor).cgColor
        } else {
            return nil
        }
    }
    func getSwitchColor() -> UIColor? {
        if let switchColor = switchColor {
            return UIColor(hex: switchColor)
        } else {
            return UIColor.white
        }
    }
    func getThumbColor() -> UIColor? {
        if let thumbColor = thumbColor {
            return UIColor(hex: thumbColor)
        } else {
            return UIColor.white
        }
    }
    func getSwitchOffColor() -> UIColor? {
        if let switchOffColor = switchOffColor {
            return UIColor(hex: switchOffColor)
        } else {
            return UIColor.white
        }
    }
}
