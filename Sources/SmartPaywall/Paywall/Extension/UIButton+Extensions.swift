//
//  UIButton+Extensions.swift
//  blocker
//
//  Created by Talip on 10.04.2023.
//

import UIKit

extension UIButton {
   public func addClickEffect() {
        self.addTarget(self, action: #selector(clickAnimation), for: .touchUpInside)
    }
    
    @objc private func clickAnimation() {
        DispatchQueue.main.async {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            
            UIView.animate(withDuration: 0.1,
                           animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
                           completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            })
        }
    }
    public func addHapticFeedback() {
          addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
      }

      @objc private func buttonTapped() {
          let generator = UIImpactFeedbackGenerator(style: .medium)
          generator.prepare()
          generator.impactOccurred()
      }
    func underline() {
        guard let title = self.titleLabel else { return }
        guard let tittleText = title.text else { return }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func startHeartbeatAnimation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = pulse.settlingDuration
        pulse.fromValue = 1
        pulse.toValue = 1.1
        pulse.initialVelocity = 0.2
        pulse.damping = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.repeatDuration = .infinity
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) // Geçiş yumuşatma
        layer.add(pulse, forKey: "pulse")
    }
    
    func stopHeartbeatAnimation() {
        layer.removeAnimation(forKey: "pulse")
    }
    
    func startVibrationAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.7 // Toplam animasyon süresi
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.values = [-15.0, 15.0, -10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        
        // Titreşim adımları arasındaki süreleri ayarlayan keyTimes
        let keyTimes: [NSNumber] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 2.0]
        animation.keyTimes = keyTimes
        
        layer.add(animation, forKey: "shake")
    }

    
    func stopVibrationAnimation() {
        layer.removeAnimation(forKey: "shake")
    }
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}
