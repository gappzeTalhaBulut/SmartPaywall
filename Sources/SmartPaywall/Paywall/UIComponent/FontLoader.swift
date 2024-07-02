//
//  File.swift
//  
//
//  Created by Talha on 29.06.2024.
//

import UIKit
import CoreText

extension UIFont {
    static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            fatalError("Couldn't find font \(fontName).\(fontExtension)")
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
            fatalError("Couldn't load data from the font \(fontName)")
        }

        guard let font = CGFont(fontDataProvider) else {
            fatalError("Couldn't create font from data")
        }

        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        if let error = error {
            print("Error registering font: \(error.takeUnretainedValue())")
        }
        return success
    }
}

public class FontRegister {
    public static func loadFonts() {
        _ = UIFont.registerFont(bundle: .module, fontName: "SF-Pro", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "SF-Pro-Display-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "SF-Pro-Display-Semibold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "Montserrat-Italic", fontExtension: "ttf")
        _ = UIFont.registerFont(bundle: .module, fontName: "Montserrat", fontExtension: "ttf")
    }
}
