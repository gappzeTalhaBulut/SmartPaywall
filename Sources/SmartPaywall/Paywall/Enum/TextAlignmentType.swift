//
//  TextAlignmentType.swift
//  BluetoothScanner
//
//  Created by Talip on 15.06.2023.
//

import UIKit

enum TextAlignmentType: String, Decodable {
    case center
    case left
    case right
    
    func convert() -> NSTextAlignment {
        switch self {
        case .center:
            return .center
        case .left:
            return .left
        case .right:
            return .right
        }
    }
}
