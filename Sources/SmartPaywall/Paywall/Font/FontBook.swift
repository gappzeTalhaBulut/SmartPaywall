//
//  File.swift
//  
//
//  Created by Talha on 29.06.2024.
//

import Foundation

enum FontBook: String, Decodable {
    
    // MARK: - Montserrat
    case montserratRegular = "MontserratRoman-Regular"
    case montserratMedium = "MontserratRoman-Medium"
    case montserratSemibold = "MontserratRoman-SemiBold"
    case montserratBold = "MontserratRoman-Bold"
    case montserratExtraBold = "MontserratRoman-ExtraBold"
    
    // MARK: - SF Pro
    case sfProRegular = "SFPro-Regular"
    case sfProMedium = "SFPro-Medium"
    case sfProSemibold = "SFPro-Semibold"
    case sfProBold = "SFPro-Bold"
    
    var actualFontName: String {
        switch self {
        case .sfProRegular:
            return "SFProDisplay-Regular"
        case .sfProMedium:
            return "SFProDisplay-Medium"
        case .sfProSemibold:
            return "SFProDisplay-Semibold"
        case .sfProBold:
            return "SFProDisplay-Bold"
        default:
            return self.rawValue
        }
    }
}

