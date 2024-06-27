//
//  BackgroundModel.swift
//  BluetoothScanner
//
//  Created by Talip on 19.06.2023.
//

import UIKit

struct BackgroundModel: Decodable {
    let type: BackgroundType
    let backgroundColor: String
    let content: BackgroundContentModel?
    
    func getCalculatedUrl() -> String {
        switch Int(UIScreen.main.scale) {
        case 1:
            return self.content?.url.md ?? ""
        case 2:
            return self.content?.url.lg ?? ""
        default:
            return self.content?.url.xl ?? ""
        }
    }
}
