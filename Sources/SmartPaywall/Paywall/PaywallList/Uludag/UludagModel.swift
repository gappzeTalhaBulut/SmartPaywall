//
//  UludagModel.swift
//  BluetoothScanner
//
//  Created by Talha on 24.01.2024.
//

import Foundation

struct UludagModel: DesignObjectProtocol {
    let title: LabelModel
    let infoList: [ListElementModel]
    let cancelInfo: LabelModel
    let subscription: SubscriptionModel
    
    func make(generalModel: PaywallGeneralModel, priceList: PriceList) -> ControllerType {
        return UludagPaywallViewController(designModel: self,
                                           generalModel: generalModel,
                                           priceList: priceList)
    }
}
