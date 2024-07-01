//
//  TextAttributeModel.swift
//  BluetoothScanner
//
//  Created by Talip on 15.06.2023.
//

import UIKit

struct TextAttributeModel: Decodable {
    let fontSize: Int
    let fontColor: String
    let isUnderlined: Bool
    let fontName: FontBook
    
    private enum CodingKeys: String, CodingKey {
        case fontSize
        case fontColor
        case isUnderlined
        case fontName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fontSize = try container.decode(Int.self, forKey: .fontSize)
        self.fontColor = try container.decode(String.self, forKey: .fontColor)
        self.isUnderlined = try container.decodeIfPresent(Bool.self, forKey: .isUnderlined) ?? false
        self.fontName = try container.decode(FontBook.self, forKey: .fontName)
    }
    func getFont() -> UIFont {
        return UIFont.customFont(from: fontName.rawValue, size: CGFloat(fontSize))
    }
}
extension UIFont {
    static func customFont(from fontBook: FontBook, size: CGFloat) -> UIFont {
        if let font = UIFont(name: fontBook.rawValue, size: size) {
            return font
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
