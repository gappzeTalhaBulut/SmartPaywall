//
//  File.swift
//  
//
//  Created by Talha on 29.06.2024.
//

import UIKit
import CoreText

public class FontLoader {
    public static func loadFonts() {
        let bundle = Bundle.module
        
        let fontNames = [
            "Montserrat-Italic",
            "Montserrat",
            "SF-Pro"
        ]
        
        for fontName in fontNames {
            guard let fontURL = bundle.url(forResource: fontName, withExtension: "ttf"),
                  let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
                  let font = CGFont(fontDataProvider) else {
                print("Error loading font: \(fontName)")
                continue
            }
            var error: Unmanaged<CFError>?
            CTFontManagerRegisterGraphicsFont(font, &error)
            if let error = error {
                print("Error registering font \(fontName): \(error.takeUnretainedValue())")
            } else {
                print("Successfully registered font: \(fontName)")
            }
        }
    }
}

