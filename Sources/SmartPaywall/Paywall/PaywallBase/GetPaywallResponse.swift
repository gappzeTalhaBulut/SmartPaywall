//
//  PaywallType.swift
//  blocker
//
//  Created by Talip on 9.04.2023.
//

import UIKit

/// Oluşturulacak tüm DesignObject ' ler bu protocol ' den miras almalı.
protocol DesignObjectProtocol: Decodable {
    func make(generalModel: PaywallGeneralModel,
              priceList: PriceList) -> any ControllerType
}

public struct GetPaywallResponse: Decodable {
    let paywall: MainPaywallModel
}

struct PaywallGeneralModel: Decodable {
    let background: BackgroundModel
    let closebutton: CloseButtonModel
    let termsOfUse: LabelModel
    let privacy: LabelModel
    let restore: LabelModel
}

struct CloseButtonModel: Decodable {
    let image: String
    let position: CloseButtonPosition
    let isVisible: Bool
    let delay: Int
    
    enum CodingKeys: CodingKey {
        case image
        case position
        case isVisible
        case delay
    }
}

enum CloseButtonPosition: String, Decodable {
    case topLeft
    case topRight
}

public struct MainPaywallModel: Decodable {
    let theme: PaywallType
    let general: PaywallGeneralModel
    let designObjects: DesignObjectProtocol
    
    private enum CodingKeys: String, CodingKey {
        case theme
        case general
        case designObjects
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.theme = try container.decode(PaywallType.self, forKey: .theme)
        self.general = try container.decode(PaywallGeneralModel.self, forKey: .general)
        self.designObjects = try container.decode(self.theme.getType(), forKey: .designObjects)
    }
}
