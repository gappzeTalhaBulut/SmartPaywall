//
//  File.swift
//  
//
//  Created by Talha on 28.06.2024.
//

import Foundation

public struct SmartPaywallParameters {
    public let placementId: Int
    public let action: String
    public let bundle: String
    public let uniqueId: String
    public let country: String
    public let language: String
    public let paywallVersion: String
    public let version: String
    public let isTest: Bool
    public let serviceURL: String
    public let serviceToken: String
    
    public init(
        placementId: Int,
        action: String,
        bundle: String,
        uniqueId: String,
        country: String,
        language: String,
        paywallVersion: String,
        version: String,
        isTest: Bool,
        serviceURL: String,
        serviceToken: String
    ) {
        self.placementId = placementId
        self.action = action
        self.bundle = bundle
        self.uniqueId = uniqueId
        self.country = country
        self.language = language
        self.paywallVersion = paywallVersion
        self.version = version
        self.isTest = isTest
        self.serviceURL = serviceURL
        self.serviceToken = serviceToken
    }
}
