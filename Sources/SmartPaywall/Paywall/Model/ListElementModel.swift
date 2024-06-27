//
//  ListElementModel.swift
//  BluetoothScanner
//
//  Created by Talip on 8.06.2023.
//

import Foundation

struct ListElementModel: Decodable {
    let image: String
    let text: String
    let title: String?
    let image2: String?
    let attributes: [TextAttributeModel]
}

/*
 "infoList": [
         {
           "image": "https://findviceapp.com/assets/img/paywall/list-blue.png",
           "text": "Find your lost device in seconds",
           "attributes": [
             {
               "fontColor": "#fff",
               "fontWeight": "medium",
               "fontSize": 17,
               "fontName": "SF Pro"
             }
           ]
         },
         {
           "image": "https://findviceapp.com/assets/img/paywall/list-blue.png",
           "text": "Supports all bluetooth devices",
           "attributes": [
             {
               "fontColor": "#fff",
               "fontWeight": "medium",
               "fontSize": 17,
               "fontName": "SF Pro"
             }
           ]
         },
         {
           "image": "https://findviceapp.com/assets/img/paywall/list-blue.png",
           "text": "Remove ADS",
           "attributes": [
             {
               "fontColor": "#fff",
               "fontWeight": "medium",
               "fontSize": 17,
               "fontName": "SF Pro"
             }
           ]
         }
       
 */
