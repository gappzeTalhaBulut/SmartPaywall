//
//  File.swift
//
//
//  Created by Talha on 31.10.2024.
//

import Foundation

struct ProductsModel {
    let bundle: String
    let uniqueId: String
    let country: String
    let language: String
    let version: String
    let isTest: Bool
    
    init(uniqueId: String,
         bundle: String,
         country: String,
         language: String,
         version: String,
         isTest: Bool) {
        self.bundle = bundle
        self.uniqueId = uniqueId
        self.country = country
        self.language = language
        self.version = version
        self.isTest = isTest
    }
}

