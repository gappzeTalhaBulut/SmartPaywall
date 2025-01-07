//
//  NetworkError.swift
//  BluetoothScanner
//
//  Created by Eda Bulut on 23.05.2023.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidUrl
    case requestFailed
    case invalidResponse
    case invalidData(String)
}
public extension DecodingError {
    var formattedDescription: String {
        switch self {
        case .keyNotFound(let key, let context):
            return "Missing Key: '\(key.stringValue)'"
                + "\nLocation: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))"
                + "\nDetails: \(context.debugDescription)"
        case .typeMismatch(let type, let context):
            return "Type Mismatch: Expected \(type)"
                + "\nLocation: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))"
                + "\nDetails: \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            return "Value Not Found: Expected \(type)"
                + "\nLocation: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))"
                + "\nDetails: \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data Corrupted"
                + "\nLocation: \(context.codingPath.map { $0.stringValue }.joined(separator: " → "))"
                + "\nDetails: \(context.debugDescription)"
        @unknown default:
            return "Unknown Decoding Error"
        }
    }
}
