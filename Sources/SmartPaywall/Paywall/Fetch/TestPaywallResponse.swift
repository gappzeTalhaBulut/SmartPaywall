//
//  File.swift
//  
//
//  Created by Talha on 20.09.2024.
//

import Foundation

public struct TestPaywallResponse: Decodable {
    let paywallJson: GetPaywallResponse
    
    public enum CodingKeys: String, CodingKey {
        case paywallJson
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paywallJson = try container.decode(GetPaywallResponse.self, forKey: .paywallJson)
    }
}


