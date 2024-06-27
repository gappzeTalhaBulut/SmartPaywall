//
//  AntalyaModel.swift
//  BluetoothScanner
//
//  Created by Talha on 22.06.2023.
//

import UIKit

struct AntalyaModel: DesignObjectProtocol {
    let title: LabelModel
    let infoList: [ListElementModel]
    let listImage: String
    let priceInfo: LabelModel
    let trialInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return AntalyaPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
