//
//  UIFactory.swift
//  BluetoothScanner
//
//  Created by Talip on 15.06.2023.
//

import UIKit

final class UIFactory {
    static func makeTermOfUseLabel(with model: PaywallGeneralModel) -> AttributedLabel {
        let label = AttributedLabel {
            URLOpener.open(with: model.termsOfUse.url ?? "")
        }
        label.set(text: model.termsOfUse.text,
                  attributeList: model.termsOfUse.attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makePrivacyPolicyLabel(with model: PaywallGeneralModel) -> AttributedLabel {
        let label = AttributedLabel {
            URLOpener.open(with: model.privacy.url ?? "")
        }
        label.set(text: model.privacy.text,
                  attributeList: model.privacy.attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeLabel(model: LabelModel) -> AttributedLabel {
        let label = AttributedLabel()
        label.textAlignment = model.textAlignment.convert()
        label.set(text: model.text, attributeList: model.attributes)
        label.numberOfLines = 0
        label.isOpaque = false
        label.isHidden = !model.isVisible
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func makeCalculatedLabel(model: LabelModel, priceList: PriceList) -> AttributedLabel {
        let label = AttributedLabel()
        label.textAlignment = model.textAlignment.convert()
        
        // Multiplier değerini kontrol edin
        let multiplier1 = 1 / (model.multiplier ?? 1.0)
        print("Multiplier 1: \(multiplier1)")  // Burada multiplier1'ı kontrol edin

        var priceFormattedString = model.text.replacePrice(with: priceList, multiplier: multiplier1)
        
        let multiplier2 = 1 / 4.0
        print("Multiplier 2: \(multiplier2)")  // Burada multiplier2'yi kontrol edin
        priceFormattedString = priceFormattedString.replacePrice(with: priceList, multiplier: multiplier2)
        
        label.set(text: priceFormattedString, attributeList: model.attributes)
        label.numberOfLines = 0
        label.isHidden = !model.isVisible
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    
    static func makePurchaseButtonWithPrice(model: SubscriptionButtonModel?, priceList: [String: (String?, String?)]) -> UIButton {
        let button = UIButton()
        if let buttonText = model?.text {
            let priceFormattedString = buttonText.replacePrice(with: priceList)
            let attributedLabel = AttributedLabel()
            attributedLabel.set(text: priceFormattedString, attributeList: model?.attributes ?? [])
            
            if let parsedText = attributedLabel.attributedText?.string {
                button.setTitle(parsedText, for: .normal)
            } else {
                button.setTitle(priceFormattedString, for: .normal)
            }
        }
        
        button.setTitleColor(UIColor(hex: model?.attributes.first?.fontColor ?? ""), for: .normal)
        button.backgroundColor = UIColor(hex: model?.backgroundColor ?? "")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = model?.getBorderColor()
        button.layer.borderWidth = model?.getBorderWidth() ?? 0
        button.titleLabel?.font = model?.attributes.first?.getFont()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    
    static func makePurchaseButton(model: SubscriptionButtonModel?) -> UIButton {
        let button = UIButton()
        button.setTitle(model?.text, for: .normal)
       // model?.animation == true ? button.startHeartbeatAnimation() : button.stopHeartbeatAnimation()
        button.setTitleColor(UIColor(hex: model?.attributes.first?.fontColor ?? ""),
                             for: .normal)
        button.backgroundColor = UIColor(hex: model?.backgroundColor ?? "")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.titleLabel?.font = model?.attributes.first?.getFont()
        button.addHapticFeedback()
        button.addClickEffect()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    static func makePurchaseButtonMarmaris(model: SubscriptionButtonModel?) -> UIButton {
        let button = UIButton()
        button.setTitle(model?.text, for: .normal)
       // model?.animation == true ? button.startHeartbeatAnimation() : button.stopHeartbeatAnimation()
        button.setTitleColor(UIColor(hex: model?.attributes.first?.fontColor ?? ""),
                             for: .normal)
        button.backgroundColor = UIColor(hex: model?.backgroundColor ?? "")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.titleLabel?.font = model?.attributes.first?.getFont()
        button.addHapticFeedback()
        button.addClickEffect()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func makeUIView(model: UIViewModel?) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: model?.backgroundColor ?? "")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func makeMarmarisUIView(model: UIViewModel?) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: model?.backgroundColor ?? "").withAlphaComponent(0.5)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 30
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    static func makeInfoListView(infoList: [ListElementModel]) -> InfoListView {
        let view = InfoListView(infoList: infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    static func makeVerticalInfoListView(infoList: [ListElementModel]) -> InfoVerticalView {
        let view = InfoVerticalView(infoList: infoList)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
//    static func makeSingleInfoListView(infoList: [ListElementModel]) -> InfoViewController {
//        let viewController = InfoViewController(infoList: infoList)
//        viewController.translatesAutoresizingMaskIntoConstraints = false
//        //viewController.infoList = infoList
//        return viewController
//    }
}
