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

        // Fiyatın içindeki nokta ve virgül işlemlerini ayarlama
        if let commaRange = lastPriceString.range(of: ",") {
            let substringBeforeComma = lastPriceString[..<commaRange.lowerBound]
            if substringBeforeComma.contains(".") {
                let cleanedString = substringBeforeComma.replacingOccurrences(of: ".", with: "")
                lastPriceString = cleanedString + lastPriceString[commaRange.lowerBound...]
            }
        }

        // Sayısal kısmı ayıklama
        let numberCharacters = Set("0123456789.,")
        let currencySymbol = lastPriceString.filter { !numberCharacters.contains($0) }
        let numericPart = lastPriceString.filter { numberCharacters.contains($0) }
        
        // Eğer fiyat virgül içeriyorsa nokta ile değiştir
        var cleanedNumericPart = numericPart.replacingOccurrences(of: ",", with: ".")
        
        // Sayısal kısmı işleme al ve multiplier uygula
        if let lastPrice = Double(cleanedNumericPart) {
            cleanedNumericPart = String(format: "%.2f", lastPrice / multiplier)
        }

        // Fiyatı sembolüyle birlikte aynı formatta geri döndür
        if !currencySymbol.isEmpty {
            if price.first?.isNumber == false {
                // Eğer sembol baştaysa
                lastPriceString = currencySymbol + cleanedNumericPart
            } else {
                // Eğer sembol sondaysa
                lastPriceString = cleanedNumericPart + currencySymbol
            }
        } else {
            lastPriceString = cleanedNumericPart
        }

        // İlk eşleşen productId'yi fiyat ile değiştir
        return self.replaceFirst(of: "{*\(productId)*}", with: "{\(lastPriceString)}")
    }

}

/*
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
 
 ________________________________________________________________
 
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

     // Para birimi sembolünü tanımla (başta veya sonda olabilir)
     var currencySymbol: String = ""
     if let firstChar = lastPriceString.first, firstChar.isCurrencySymbol {
         // Eğer ilk karakter bir sembolse onu al
         currencySymbol = String(firstChar)
         lastPriceString = String(lastPriceString.dropFirst()) // Sembolden kurtul
     } else if let lastChar = lastPriceString.last, lastChar.isCurrencySymbol {
         // Eğer son karakter bir sembolse onu al
         currencySymbol = String(lastChar)
         lastPriceString = String(lastPriceString.dropLast()) // Sembolden kurtul
     }

     if multiplier != 1.0 {
         print("Before applying multiplier: \(lastPriceString)")

         // Sembolden arındırılmış fiyata multiplier uygula
         if let lastPrice = Double(lastPriceString) {
             lastPriceString = String(format: "%.2f", lastPrice * multiplier)
             print("After applying multiplier: \(lastPriceString)")
         }
     }

     // Sembolü fiyatın başına veya sonuna ekle (mevcut yerleşimine göre)
     if !currencySymbol.isEmpty {
         if price.first == currencySymbol.first {
             // Sembol başta ise fiyatın başına ekle
             lastPriceString = currencySymbol + lastPriceString
         } else {
             // Sembol sonda ise fiyatın sonuna ekle
             lastPriceString += currencySymbol
         }
     }

     // İlk eşleşen productId'yi fiyat ile değiştir
     return self.replaceFirst(of: "{*\(productId)*}", with: "{\(lastPriceString)}")
 }
 */
