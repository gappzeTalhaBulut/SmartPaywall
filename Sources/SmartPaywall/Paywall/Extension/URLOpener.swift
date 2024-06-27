//
//  URLOpener.swift
//  BluetoothScanner
//
//  Created by Talip on 19.06.2023.
//

import UIKit

final class URLOpener {
    static func open(with link: String) {
        if let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Can not open URL: \(link)")
            }
        } else {
            print("Invalid URL: \(link)")
        }
    }
}
