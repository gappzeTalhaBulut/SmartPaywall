//
//  AyderModel.swift
//  BluetoothScanner
//
//  Created by Talha on 31.01.2024.
//

import Foundation

struct AyderModel: DesignObjectProtocol {
    let title: LabelModel
    let cancelInfo: LabelModel
    let priceInfo: LabelModel
    let trialInfo: LabelModel
    let sliderInfo: [ListElementModel]
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return AyderPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
