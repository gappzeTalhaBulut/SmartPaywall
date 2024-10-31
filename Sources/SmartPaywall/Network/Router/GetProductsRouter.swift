//
//  File.swift
//  
//
//  Created by Talha on 31.10.2024.
//

import Foundation

enum GetProductsRouter: NetworkEndpointConfiguration {
    case products(model: ProductsModel, serviceURL: String, serviceToken: String)
    
    var method: HTTPMethodType {
        return .post
    }
    
    var path: String {
        switch self {
        case .products(_, let serviceURL, _):
            return serviceURL
        }
    }
    
    var parametersBody: Data? {
        switch self {
            case .products(let model, _ ,_):
            let body: [String: Any] = [
                "bundle": model.bundle,
                "unique-id": model.uniqueId,
                "country": model.country.uppercased(),
                "lang": model.language.uppercased(),
                "version": model.version,
                "isTest": model.isTest,
            ]
            debugPrint("\(body)")
            return body.convert()
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .products(_, _, let serviceToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(serviceToken)"
            ]
        }
    }
    
    var timeoutInterval: TimeInterval {
        return 10
    }
}
