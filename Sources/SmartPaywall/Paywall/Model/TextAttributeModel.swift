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
        case fontSize, fontColor, isUnderlined, fontName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fontSize = try container.decode(Int.self, forKey: .fontSize)
        self.fontColor = try container.decode(String.self, forKey: .fontColor)
        self.isUnderlined = try container.decodeIfPresent(Bool.self, forKey: .isUnderlined) ?? false
        self.fontName = try container.decode(FontBook.self, forKey: .fontName)
    }
    
    func getFont() -> UIFont {
        let adjustedFontSize = adjustFontSize(for: UIDevice.current.userInterfaceIdiom)
        if let font = UIFont(name: fontName.actualFontName, size: CGFloat(adjustedFontSize)) {
            return font
        } else {
            print("Font not found: \(fontName.actualFontName), reverting to system font.")
            return UIFont.systemFont(ofSize: CGFloat(adjustedFontSize))
        }
    }
    
    private func adjustFontSize(for idiom: UIUserInterfaceIdiom) -> Int {
        switch idiom {
        case .pad:
            return Int(Double(fontSize) * 1.2)
        case .phone:
            fallthrough
        default:
            return fontSize
        }
    }
    
    func getFontColor() -> UIColor {
        return UIColor(named: fontColor) ?? UIColor.black
    }
}
