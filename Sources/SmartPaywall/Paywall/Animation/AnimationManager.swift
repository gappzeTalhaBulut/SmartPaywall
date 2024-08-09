//
//  AnimationManager.swift
//  BluetoothScanner
//
//  Created by Talha on 25.08.2023.
//

import UIKit

public class AnimationManager {
    static let shared = AnimationManager()
    
    private init() {}
    
    func startAnimation(_ animationType: AnimationType, on button: UIButton) {
        switch animationType {
        case .heartbeat:
            button.startHeartbeatAnimation()
        case .vibration:
            button.startVibrationAnimation()
        }
    }
    
    func stopAnimation(_ animationType: AnimationType, on button: UIButton) {
        switch animationType {
        case .heartbeat:
            button.stopHeartbeatAnimation()
        case .vibration:
            button.stopVibrationAnimation()
        }
    }
}

