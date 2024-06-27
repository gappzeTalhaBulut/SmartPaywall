//
//  SmartPaywallModel.swift
//  CallRecorder
//
//  Created by Eda Bulut on 18.04.2024.
//

import Foundation

struct SmartPaywallModel {
    let bundle: String
    let uniqueId: String
    let placementId: Int
    let actionName: String
    let country: String
    let language: String
    let paywallVersion: String
    let version: String
    let isTest: Bool
    
    init(placementId: Int,
          action: AppPaywallAction,
          uniqueId: String,
          bundle: String,
          country: String,
          language: String,
          paywallVersion: String,
          version: String,
         isTest: Bool) {
        self.bundle = bundle
        self.uniqueId = uniqueId
        self.placementId = placementId
        self.actionName = action.rawValue
        self.country = country
        self.language = language
        self.paywallVersion = paywallVersion
        self.version = version
        self.isTest = isTest
    }
}

