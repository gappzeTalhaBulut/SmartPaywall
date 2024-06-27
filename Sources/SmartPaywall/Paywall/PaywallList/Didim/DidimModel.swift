//
//  DidimModel.swift
//  BluetoothScanner
//
//  Created by Talha on 23.06.2023.
//

import UIKit

struct DidimModel: DesignObjectProtocol {
    let title: LabelModel
    let infoList: [ListImageTextModel]
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let cancelInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]

    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return DidimPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}

