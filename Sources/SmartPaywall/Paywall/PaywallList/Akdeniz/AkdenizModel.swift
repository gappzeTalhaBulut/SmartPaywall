//
//  File.swift
//  
//
//  Created by Talha on 11.10.2024.
//

import Foundation

struct AkdenizModel: DesignObjectProtocol {
    let title: LabelModel
    let subtitle: LabelModel
    let infoList: [ListElementModel]
    let cancelInfo: LabelModel
    let subscription: SubscriptionMultiplierModel
    
    func make(generalModel: PaywallGeneralModel, priceList: PriceList) -> ControllerType {
        return AkdenizPaywallViewController(designModel: self,
                                           generalModel: generalModel,
                                           priceList: priceList)
    }
}
