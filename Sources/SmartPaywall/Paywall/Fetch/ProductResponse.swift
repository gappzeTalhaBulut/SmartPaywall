//
//  File.swift
//  
//
//  Created by Talha on 31.10.2024.
//

import Foundation

struct ProductResponse: Decodable {
    let status: String
    let subscriptionProducts: [String]
}
