//
//  FethiyeModel.swift
//  BluetoothScanner
//
//  Created by Talip on 19.06.2023.
//

import Foundation

struct FethiyeModel: DesignObjectProtocol {
    let centerImage: String
    let title: LabelModel
    let subTitle: LabelModel
    let priceInfo: LabelModel
    let trialInfo: LabelModel
    let cancelInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return FethiyePaywallViewController(designModel: self,
                                            generalModel: generalModel,
                                            priceList: priceList)
    }
}

