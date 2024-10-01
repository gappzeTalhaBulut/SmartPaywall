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
    func replacePriceWithDivisionFactor(with list: PriceList, divisionFactor: Double = 1.0) -> String {
        guard let productId = self.getProductId() else { return self }
        guard let priceInfo = list[productId] else { return self }
        guard let price = priceInfo.localizedPrice, let currencySymbol = priceInfo.currencySymbol else { return self }

        // Fiyatı işleme
        var lastPriceString = price.replacingOccurrences(of: ",", with: ".")
        
        if let lastPrice = Double(lastPriceString) {
            let dividedPrice = lastPrice / divisionFactor
            lastPriceString = String(format: "%.2f", dividedPrice)
        }
        
        return self.replaceFirst(of: "{*\(productId)*}", with: "{\(currencySymbol)\(lastPriceString)}")
    }
    
    func replacePrice(with list: [String: (String?, String?)], multiplier: Double = 1.0) -> String {
        guard let productId = self.getProductId() else { return self }
        guard let price = list[productId]?.0 else { return self }
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
            if let currencySymbol = list[productId]?.1 {
                if currencySymbol.first == price.first {
                    lastPriceString.removeFirst()
                    if let lastPrice = Double(lastPriceString) {
                        lastPriceString = currencySymbol + String(format: "%.2f", lastPrice * multiplier)
                    }
                } else if currencySymbol.first == price.last {
                    lastPriceString.removeLast()
                    if let lastPrice = Double(lastPriceString) {
                        lastPriceString = String(format: "%.2f", lastPrice * multiplier) + currencySymbol
                    }
                }
                
            }
        }
        return self.replaceFirst(of: "{*\(productId)*}", with: "{\(lastPriceString)}")
    }
}
