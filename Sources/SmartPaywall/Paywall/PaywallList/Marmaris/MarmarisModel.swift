//
//  MarmarisModel.swift
//  BluetoothScanner
//
//  Created by Talha on 2.09.2023.
//

import Foundation

struct MarmarisModel: DesignObjectProtocol {
    let title: LabelModel
    let infoList: [ListElementModel]
    var priceInfo: LabelModel
    var priceInfo2: LabelModel
    let cancelInfo: LabelModel
    let trialTitle: LabelModel
    let trialSubtitle: LabelModel
    let trialView: UIViewModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return MarmarisPaywallViewController(designModel: self,
                                            generalModel: generalModel,
                                            priceList: priceList)
    }
}

