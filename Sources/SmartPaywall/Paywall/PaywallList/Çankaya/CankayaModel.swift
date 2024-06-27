//
//  CankayaModel.swift
//  BluetoothScanner
//
//  Created by Talha on 18.10.2023.
//

import Foundation

struct CankayaModel: DesignObjectProtocol {
    let title: LabelModel
    let infoList: [ListElementModel]
    let switchView: UIViewModel
    let switchTitle: LabelModel
    let trialSubtitle: LabelModel
    let trialTitle: LabelModel
    let trialView: UIViewModel
    let purchaseTitle: LabelModel
    let purchaseSubtitle: LabelModel
    let purchaseView: UIViewModel
    let trialTagText: LabelModel
    let subscribeButtons: [SubscriptionButtonModel]
    let cancelInfo: LabelModel
    let trialSelectedImage: String
    let purchaseSelectedImage: String
    
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> ControllerType {
        return CankayaPaywallViewController(designModel: self,
                                            generalModel: generalModel,
                                            priceList: priceList)
    }
}

// trial selected: "https://findviceapp.com/assets/img/paywall/selected.png"
