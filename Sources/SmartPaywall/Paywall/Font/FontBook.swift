//
//  FontBook.swift
//  BluetoothScanner
//
//  Created by Talip on 14.06.2023.
//

import UIKit

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
}
