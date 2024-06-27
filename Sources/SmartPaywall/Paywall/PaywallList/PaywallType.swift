//
//  PaywallType.swift
//  MeditationApp
//
//  Created by Talip on 25.04.2023.
//

import Foundation

/// Yeni gelen paywall ' lar buraya eklenicek.
enum PaywallType: String, Decodable {
    case dege = "dege"
    case fethiye = "fethiye"
    case cesme = "cesme"
    case antalya = "antalya"
    case macka = "macka"
    case didim = "didim"
    case erciyes = "erciyes"
    case pamukkale = "pamukkale"
    case atakum = "atakum"
    case bodrum = "bodrum"
    case marmaris = "marmaris"
    case cankaya = "cankaya"
    case uludag = "uludag"
    case aspendos = "aspendos"
    case kusadasi = "kusadasi"
    case bursa = "bursa"
    case ayder = "ayder"
    case istanbul = "istanbul"
    
    func getType() -> DesignObjectProtocol.Type {
        switch self {
        case .dege:
            return DegeModel.self
        case .fethiye:
            return FethiyeModel.self
        case .cesme:
            return CesmeModel.self
        case .antalya:
            return AntalyaModel.self
        case .macka:
            return MackaModel.self
        case .didim:
            return DidimModel.self
        case .erciyes:
            return ErciyesModel.self
        case .pamukkale:
            return PamukkaleModel.self
        case .atakum:
            return AtakumModel.self
        case . bodrum:
            return BodrumModel.self
        case .marmaris:
            return MarmarisModel.self
        case .cankaya:
            return CankayaModel.self
        case .uludag:
            return UludagModel.self
        case .aspendos:
            return AspendosModel.self
        case .kusadasi:
            return KusadasıModel.self
        case .bursa:
            return BursaModel.self
        case .ayder:
            return AyderModel.self
        case .istanbul:
            return IstanbulModel.self
        }
    }
}

