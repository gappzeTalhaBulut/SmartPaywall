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
    let subscriptionSecond: SubscriptionMultiplierModel
    
    func make(generalModel: PaywallGeneralModel, priceList: PriceList) -> ControllerType {
        return AtakumPaywallViewController(designModel: self,
                                           generalModel: generalModel,
                                           priceList: priceList)
    }
}
struct SubscriptionMultiplierModel: Decodable {
    let option: SubscriptionOptionMultiplierModel
    let subscribeButtons: [SubscriptionButtonModel]
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

struct SubscriptionOptionMultiplierModel: Decodable {
    let backgroundColor: String
    let selectedImage: String?
    let unSelectedImage: String?
    let selectedColor: String
    var productList: [SubscriptionMultiplierProductModel]
    let textAttributes: [TextAttributeModel]?
}

struct SubscriptionMultiplierProductModel: Decodable {
    let productName: String
    let subText: String
    let productId: String
    var isSelected: Bool
    var ticketValue: String
    let multiplier: Double?
    let multiplier2: Double?
    
    private enum CodingKeys: String, CodingKey {
        case productName
        case subText
        case productId
        case isSelected
        case ticketValue
        case multiplier
        case multiplier2
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName) ?? ""
        self.subText = try container.decodeIfPresent(String.self, forKey: .subText) ?? ""
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId) ?? ""
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        self.ticketValue = try container.decodeIfPresent(String.self, forKey: .ticketValue) ?? ""
        self.multiplier = try container.decodeIfPresent(Double.self, forKey: .multiplier) ?? 1.0
        self.multiplier2 = try container.decodeIfPresent(Double.self, forKey: .multiplier) ?? 1.0
    }
}

struct SubscriptionProductModel: Decodable {
    let productName: String
    let subText: String
    let productId: String
    var isSelected: Bool
    var ticketValue: String
    
    private enum CodingKeys: String, CodingKey {
        case productName
        case subText
        case productId
        case isSelected
        case ticketValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.subText = try container.decodeIfPresent(String.self, forKey: .subText) ?? ""
        self.productId = try container.decode(String.self, forKey: .productId)
        self.isSelected = try container.decodeIfPresent(Bool.self, forKey: .isSelected) ?? false
        self.ticketValue = try container.decodeIfPresent(String.self, forKey: .ticketValue) ?? ""
    }
}
