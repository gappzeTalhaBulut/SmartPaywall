//
//  IstanbulModel.swift
//  BluetoothScanner
//
//  Created by Talha on 31.01.2024.
//

import Foundation

struct IstanbulModel: DesignObjectProtocol {
    let title: LabelModel
    let viewColor: String
    let infoList: [ListElementModel]
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let cancelInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return IstanbulPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
