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
