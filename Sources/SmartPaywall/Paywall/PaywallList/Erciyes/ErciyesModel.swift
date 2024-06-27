//
//  ErciyesModel.swift
//  BluetoothScanner
//
//  Created by Talha on 30.06.2023.
//

import Foundation

struct ErciyesModel: DesignObjectProtocol {
    let centerImage: String
    let title: LabelModel
    let infoList: [ListElementModel]
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    let cancelInfo: LabelModel
    
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return ErciyesPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
