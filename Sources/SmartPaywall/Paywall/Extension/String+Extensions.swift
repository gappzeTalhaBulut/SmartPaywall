//
//  String+Extensions.swift
//  BluetoothScanner
//
//  Created by Talip on 13.06.2023.
//

import Foundation

extension String {
    func getProductId() -> String? {
        if let startRange = self.range(of: "{*") {
            let startIndex = startRange.upperBound
            if let endRange = self.range(of: "*}") {
                let endIndex = endRange.lowerBound
                let value = self[startIndex..<endIndex]
                return String(value)
            }
        }
        return nil
    }
    
    func replaceFirst(of pattern:String,
                      with replacement:String) -> String {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        } else {
            return self
        }
    }
    
    func replacePrice(with list: [String: (String?, String?)], multiplier: Double = 1.0) -> String {
        guard let productId = self.getProductId() else {
            print("No valid product ID found.")
            return self
        }
        
        guard let price = list[productId]?.0 else {
            print("Price not found for product ID: \(productId)")
            return self
        }
        
        var lastPriceString = price

        if let commaRange = lastPriceString.range(of: ",") {
            let substringBeforeComma = lastPriceString[..<commaRange.lowerBound]
            if substringBeforeComma.contains(".") {
                let cleanedString = substringBeforeComma.replacingOccurrences(of: ".", with: "")
                lastPriceString = cleanedString + lastPriceString[commaRange.lowerBound...]
            }
        }

        lastPriceString = lastPriceString.replacingOccurrences(of: ",", with: ".")
        
        if multiplier != 1.0 {
            print("Before applying multiplier: \(lastPriceString)")
            if let currencySymbol = list[productId]?.1 {
                print("Currency symbol found: \(currencySymbol)")
                if currencySymbol.first == price.first {
                    lastPriceString.removeFirst()
                    if let lastPrice = Double(lastPriceString) {
                        lastPriceString = currencySymbol + String(format: "%.2f", lastPrice * multiplier)
                        print("After applying multiplier: \(lastPriceString)")
                    }
                } else if currencySymbol.first == price.last {
                    lastPriceString.removeLast()
                    if let lastPrice = Double(lastPriceString) {
                        lastPriceString = String(format: "%.2f", lastPrice * multiplier) + currencySymbol
                        print("After applying multiplier: \(lastPriceString)")
                    }
                }
            } else {
                print("No currency symbol found for product ID: \(productId)")
            }
        } else {
            print("Multiplier is 1.0, skipping...")
        }
        
        return self.replaceFirst(of: "{*\(productId)*}", with: "{\(lastPriceString)}")
    }

}
