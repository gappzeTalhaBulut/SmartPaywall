//
//  BackgroundContentModel.swift
//  BluetoothScanner
//
//  Created by Talip on 19.06.2023.
//

import Foundation

struct BackgroundContentModel: Decodable {
    let url: ContentURLModel
    let isLoopEnabled: Bool
    
    private enum CodingKeys: String, CodingKey {
        case url
        case isLoopEnabled = "loop"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(ContentURLModel.self, forKey: .url)
        self.isLoopEnabled = try container.decodeIfPresent(Bool.self, forKey: .isLoopEnabled) ?? false
    }
}
