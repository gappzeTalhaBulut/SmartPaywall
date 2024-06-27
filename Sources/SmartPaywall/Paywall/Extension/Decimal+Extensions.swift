//
//  Decimal+Extensions.swift
//  BluetoothScanner
//
//  Created by Talip on 27.06.2023.
//

import Foundation

extension Decimal {
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
