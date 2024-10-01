//
//  AtakumModel.swift
//  BluetoothScanner
//
//  Created by Talip on 6.07.2023.
//

import Foundation

struct AtakumModel: DesignObjectProtocol {
    let title: LabelModel
    let infoList: [ListElementModel]
    let cancelInfo: LabelModel
    let subscription: SubscriptionModel
    
    func make(generalModel: PaywallGeneralModel, priceList: PriceList) -> ControllerType {
        return AtakumPaywallViewController(designModel: self,
                                           generalModel: generalModel,
                                           priceList: priceList)
    }
}

struct SubscriptionModel: Decodable {
    let option: SubscriptionOptionModel
    let subscribeButtons: [SubscriptionButtonModel]
}

struct SubscriptionOptionModel: Decodable {
    let backgroundColor: String
    let selectedImage: String?
    let unSelectedImage: String?
    let selectedColor: String
    var productList: [SubscriptionProductModel]
}

struct SubscriptionProductModel: Decodable {
    let productName: String
    let subText: String
    let productId: String
    var isSelected: Bool
    var ticketValue: String
    let multiplier: Double
    
    private enum CodingKeys: String, CodingKey {
        case productName
        case subText
        case productId
        case isSelected
        case ticketValue
        case multiplier
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.subText = try container.decodeIfPresent(String.self, forKey: .subText) ?? ""
        self.productId = try container.decode(String.self, forKey: .productId)
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        self.ticketValue = try container.decodeIfPresent(String.self, forKey: .ticketValue) ?? ""
        self.multiplier = try container.decodeIfPresent(Double.self, forKey: .multiplier) ?? 1.0
    }
}
