//
//  SmartPaywallRouter.swift
//  CallRecorder
//
//  Created by Eda Bulut on 18.04.2024.
//

import Foundation

enum SmartPaywallRouter: NetworkEndpointConfiguration {
    case smartPaywall(model: SmartPaywallModel, serviceURL: String, serviceToken: String)
    
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
                "action": model.actionName,
                "experimentId": model.placementId,
                "paywallVersion": model.paywallVersion,
                "version": model.version,
                "isTest": model.isTest,
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

extension Dictionary where Key == String, Value == Any {
    func convert() -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return  nil }
        guard let json = String(data: data, encoding: .utf8) else { return nil}
        return json.data(using: .utf8)
    }
}
