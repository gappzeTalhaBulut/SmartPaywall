//
//  CloseButtonProtocol.swift
//  BluetoothScanner
//
//  Created by Talip on 15.06.2023.
//

import UIKit

protocol CloseButtonProtocol: AnyObject {
    var closeButton: UIButton { get set }
    func applyCloseButtonLogic(isVisible: Bool, delay: Int)
}

extension CloseButtonProtocol {
    func applyCloseButtonLogic(isVisible: Bool, delay: Int) {
        if isVisible {
            var dispatchAfter = DispatchTimeInterval.milliseconds(delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter, execute: { [weak self] in
                self?.closeButton.isHidden = false
            })
        } else {
            closeButton.isHidden = true
        }
    }
}
