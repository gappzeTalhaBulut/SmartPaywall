//
//  File.swift
//  
//
//  Created by Talha on 20.09.2024.
//

import Foundation

struct TestPaywallModel {
    let bundle: String
    let uniqueId: String
    let paywallId: Int
    let country: String
    let language: String
    let paywallVersion: String
    let version: String
    let isCdn: Bool
    
    init(paywallId: Int,
          uniqueId: String,
          bundle: String,
          country: String,
          language: String,
          paywallVersion: String,
          version: String,
         isCdn: Bool) {
        self.bundle = bundle
        self.uniqueId = uniqueId
        self.paywallId = paywallId
        self.country = country
        self.language = language
        self.paywallVersion = paywallVersion
        self.version = version
        self.isCdn = isCdn
    }
}

