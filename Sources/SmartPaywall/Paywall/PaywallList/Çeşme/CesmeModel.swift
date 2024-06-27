//
//  ÇeşmeModel.swift
//  BluetoothScanner
//
//  Created by Talha on 21.06.2023.
//

import UIKit

struct CesmeModel: DesignObjectProtocol {
    let listInfotext: LabelModel
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let infoList: [ListElementModel]
    let unlockInfo: [ListElementModel]
    let cancelInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return CesmePaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
