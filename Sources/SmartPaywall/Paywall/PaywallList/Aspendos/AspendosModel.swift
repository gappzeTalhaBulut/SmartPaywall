//
//  AspendosModel.swift
//  BluetoothScanner
//
//  Created by Talha on 26.01.2024.
//

import Foundation

struct AspendosModel: DesignObjectProtocol {
    let title: LabelModel
    let subtitle: LabelModel
    let timerValue: Int
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return AspendosPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
