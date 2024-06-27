//
//  DegeModel.swift
//  blocker
//
//  Created by Talip on 9.04.2023.
//

import UIKit

struct DegeModel: DesignObjectProtocol {
    let title: LabelModel
    let trialInfo: LabelModel
    let priceInfo: LabelModel
    let cancelInfo: LabelModel
    let infoList: [ListElementModel]
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return DegePaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}

