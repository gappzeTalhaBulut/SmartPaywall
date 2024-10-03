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
        guard let productId = self.getProductId() else { return self }
        guard let price = list[productId]?.0 else { return self }
        var lastPriceString = price

        // Eğer fiyat virgül içeriyorsa nokta ile değiştir
        if let commaRange = lastPriceString.range(of: ",") {
            let substringBeforeComma = lastPriceString[..<commaRange.lowerBound]
            if substringBeforeComma.contains(".") {
                let cleanedString = substringBeforeComma.replacingOccurrences(of: ".", with: "")
                lastPriceString = cleanedString + lastPriceString[commaRange.lowerBound...]
            }
        }

        lastPriceString = lastPriceString.replacingOccurrences(of: ",", with: ".")
        
        // Currency symbol price string'in ilk karakteri olacak
        let currencySymbol = String(price.first!)
        
        if multiplier != 1.0 {
            print("Before applying multiplier: \(lastPriceString)")
            
            // İlk karakterin currency symbol olup olmadığını kontrol ediyoruz
            if let lastPrice = Double(lastPriceString.dropFirst()) {
                lastPriceString = currencySymbol + String(format: "%.2f", lastPrice * multiplier)
                print("After applying multiplier: \(lastPriceString)")
            }
        }

        // İlk eşleşen productId'yi fiyat ile değiştir
        return self.replaceFirst(of: "{*\(productId)*}", with: "{\(lastPriceString)}")
    }

}
