//
//  BodrumModel.swift
//  BluetoothScanner
//
//  Created by Talha on 2.08.2023.
//

import Foundation

struct BodrumModel: DesignObjectProtocol {
    let centerImage: String
    let title: LabelModel
    let infoList: [ListTextModel]
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    let cancelInfo: LabelModel
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return BodrumPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
