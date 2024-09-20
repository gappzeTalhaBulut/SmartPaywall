//
//  File.swift
//  
//
//  Created by Talha on 20.09.2024.
//

import Foundation

enum TestPaywallRouter: NetworkEndpointConfiguration {
    case smartPaywall(model: TestPaywallModel, serviceURL: String, serviceToken: String)
    
    var method: HTTPMethodType {
        return .post
    }
    
    var path: String {
        switch self {
        case .smartPaywall(_, let serviceURL, _):
            return serviceURL
        }
    }
    
    var parametersBody: Data? {
        switch self {
            case .smartPaywall(let model, _ ,_):
            let body: [String: Any] = [
                "bundle": model.bundle,
                "unique-id": model.uniqueId,
                "country": model.country.uppercased(),
                "lang": model.language.uppercased(),
                "paywallId": model.paywallId,
                "paywallVersion": model.paywallVersion,
                "version": model.version,
                "isCdn": model.isCdn
            ]
            debugPrint("\(body)")
            return body.convert()
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .smartPaywall(_, _, let serviceToken):
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
