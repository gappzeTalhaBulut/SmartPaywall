//
//  PamukkaleModel.swift
//  BluetoothScanner
//
//  Created by Talha on 3.07.2023.
//

import Foundation

struct PamukkaleModel: DesignObjectProtocol {
    let title: LabelModel
    let description: LabelModel
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    let cancelInfo: LabelModel
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return PamukkalePaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
