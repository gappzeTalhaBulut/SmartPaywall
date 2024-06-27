//
//  KusadasıModel.swift
//  BluetoothScanner
//
//  Created by Talha on 29.01.2024.
//

import Foundation

struct KusadasıModel: DesignObjectProtocol {
    let infoList: [ListElementModel]
    let subscription: SubscriptionModel
    let cancelInfo: LabelModel
    
    func make(generalModel: PaywallGeneralModel, priceList: PriceList) -> ControllerType {
        return KusadasıPaywallViewController(designModel: self,
                                           generalModel: generalModel,
                                           priceList: priceList)
    }
    
}
