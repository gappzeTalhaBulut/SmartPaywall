//
//  SmartPaywallResponse.swift
//  CallRecorder
//
//  Created by Eda Bulut on 18.04.2024.
//

import Foundation

struct SmartPaywallResponse: Decodable {
    let status: String
    let paywallId: Int
    let paywallName: String?
    let isABTest: Bool
    let ABTestName: String
    let clientLang: String
    let paywallLang: String
    let paywallJson: GetPaywallResponse
    
    enum CodingKeys: String, CodingKey {
        case status
        case paywallId
        case paywallName
        case isABTest
        case ABTestName
        case clientLang
        case paywallLang
        case paywallJson
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.paywallId = try container.decode(Int.self, forKey: .paywallId)
        self.paywallName = try container.decodeIfPresent(String.self, forKey: .paywallName)
        self.isABTest = try container.decode(Bool.self, forKey: .isABTest)
        self.ABTestName = try container.decode(String.self, forKey: .ABTestName)
        self.clientLang = try container.decode(String.self, forKey: .clientLang)
        self.paywallLang = try container.decode(String.self, forKey: .paywallLang)
        self.paywallJson = try container.decode(GetPaywallResponse.self, forKey: .paywallJson)
      
    }
}

