//
//  MackaModel.swift
//  BluetoothScanner
//
//  Created by Talha on 22.06.2023.
//

import Foundation

struct MackaModel: DesignObjectProtocol {
    let centerImage: String
    let title: LabelModel
    let infoList: [ListElementModel]
    let trialInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return MackaPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
