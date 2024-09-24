//
//  File.swift
//  
//
//  Created by Talha on 20.09.2024.
//

import Foundation

public struct TestPaywallParameters {
    public let paywallId: Int
    public let bundle: String
    public let uniqueId: String
    public let country: String
    public let language: String
    public let paywallVersion: String
    public let version: String
    public let serviceURL: String
    public let serviceToken: String
    public let isCdn: Bool
    
    public init(
        paywallId: Int,
        bundle: String,
        uniqueId: String,
        country: String,
        language: String,
        paywallVersion: String,
        version: String,
        serviceURL: String,
        serviceToken: String,
        isCdn: Bool
    ) {
        self.paywallId = paywallId
        self.bundle = bundle
        self.uniqueId = uniqueId
        self.country = country
        self.language = language
        self.paywallVersion = paywallVersion
        self.version = version
        self.serviceURL = serviceURL
        self.serviceToken = serviceToken
        self.isCdn = isCdn
    }
}

