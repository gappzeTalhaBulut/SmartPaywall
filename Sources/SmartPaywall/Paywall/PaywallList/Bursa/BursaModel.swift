//
//  BursaModel.swift
//  BluetoothScanner
//
//  Created by Talha on 30.01.2024.
//

import Foundation

struct BursaModel: DesignObjectProtocol {
    let title: LabelModel
    let description: LabelModel // -> new price list, info list silindi
    let pageDots: ColorPalette
    
    let sliderInfo: [ListImageTextModel]
    let cancelInfo: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return BursaPaywallViewController(designModel: self,
                                         generalModel: generalModel,
                                         priceList: priceList)
    }
}
