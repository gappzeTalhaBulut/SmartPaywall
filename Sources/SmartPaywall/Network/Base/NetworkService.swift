//
//  NetworkService.swift
//  BluetoothScanner
//
//  Created by Eda Bulut on 23.05.2023.
//

import Foundation

public protocol NetworkProtocol {
    func request<T: Decodable>(route: NetworkEndpointConfiguration,
                               result: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkService: NetworkProtocol {
    public let isLoggingEnabled: Bool
    
    public init(isLoggingEnabled: Bool = true) {
        self.isLoggingEnabled = isLoggingEnabled
    }
    
    public func request<T: Decodable>(route: NetworkEndpointConfiguration,
                               result: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: route.path) else {
            result(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = route.method.rawValue
        request.httpBody = route.parametersBody
        request.allHTTPHeaderFields = route.headers
        request.timeoutInterval = route.timeoutInterval
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                result(.failure(.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                result(.failure(.invalidResponse))
                return
            }
            
            guard let responseData = data else {
                result(.failure(.invalidData("")))
                return
            }
            
            if self.isLoggingEnabled == true { self.logJSONResponse(data: responseData) }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: responseData)
                result(.success(decodedResponse))
            } catch {
                if let decodingError = error as? DecodingError {
                    let formattedError = "Decoding Error:\n\(decodingError.formattedDescription)"
                    result(.failure(.invalidData(String(describing: formattedError))))
                } else {
                    let errorDescription = "Unknown Error:\n\(error.localizedDescription)"
                    result(.failure(.invalidData(String(describing: errorDescription))))
                }
            }
        }.resume()
    }
}

// MARK: Private Methods
public extension NetworkService {
    func logJSONResponse(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print(String(decoding: jsonData, as: UTF8.self))
        } else {
            print("json data malformed")
        }
    }
}
