//
//  PaywallControllerProtocol.swift
//  blocker
//
//  Created by Talip on 9.04.2023.
//

import UIKit

typealias ControllerType = UIViewController & PaywallControllerProtocol

/// Oluşturulacak tüm paywall ' ların controller ' ları bu protocol ' den miras almalı
protocol PaywallControllerProtocol {
    /// Paywall açıldığında tetiklencek.
    var onOpen: (() -> ())? { get set }
    var onClose: (() -> ())? { get set }
    var onPurchase: ((String) -> ())? { get set }
    var onRestore: (() -> ())? { get set }
    func closePaywall(didClose: @escaping () -> ())
}
