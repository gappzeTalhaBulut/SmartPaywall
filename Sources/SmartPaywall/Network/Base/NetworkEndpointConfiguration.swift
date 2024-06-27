//
//  NetworkEndpointConfiguration.swift
//  BluetoothScanner
//
//  Created by Eda Bulut on 23.05.2023.
//

import Foundation

protocol NetworkEndpointConfiguration {
    var method: HTTPMethodType { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parametersBody: Data? { get }
    var timeoutInterval: TimeInterval { get }
}
