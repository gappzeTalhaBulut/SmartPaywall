//
//  AttributedLabel.swift
//  BluetoothScanner
//
//  Created by Talip on 8.06.2023.
//

import UIKit

class AttributedLabel: UILabel {
    private var didClick: (() -> ())?
    
    init(didClick: (() -> ())? = nil) {
        super.init(frame: .zero)
        self.didClick = didClick
        if didClick != nil {
            self.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(didClickLabel))
            self.addGestureRecognizer(tap)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func set(text: String, attributeList: [TextAttributeModel]) {
        let model = findRanges(text: text)
        let fullString = model.trimmedText

        let fullAttributedString = NSAttributedString(string: fullString, attributes: getAttributes(model: attributeList.first))
        let fullMutableAttributedString = NSMutableAttributedString(attributedString: fullAttributedString)

        // index + 1 yerine index kontrolü yap
        for (index, range) in model.ranges.enumerated() {
            // attributeList'in boyutunu kontrol et
            guard index + 1 < attributeList.count else {
                print("Attribute list index out of range for index: \(index)")
                continue // Eğer index geçerli değilse devam et
            }
            let attributes = attributeList[index + 1]
            fullMutableAttributedString.addAttributes(getAttributes(model: attributes), range: range)
        }

        self.attributedText = fullMutableAttributedString
    }


    @objc
    private func didClickLabel() {
        self.didClick?()
    }
}

private extension AttributedLabel {
    func findRanges(text: String) -> (trimmedText: String,ranges: [NSRange]) {
        var stack: [Character] = []
        var ranges: [NSRange] = []

        var lastStartedPoint: Int = 0
        
        for char in text {
            if char == "{" {
                lastStartedPoint = stack.count
            } else if char == "}" {
                let newRange = NSRange(location: lastStartedPoint, length: stack.count - lastStartedPoint)
                ranges.append(newRange)
            } else {
                stack.append(char)
            }
        }
        return (String(stack), ranges)
    }
    
    func getAttributes(model: TextAttributeModel?) -> [NSAttributedString.Key : Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]
    
        if let font = model?.getFont() {
            attributes[.font] = model?.getFont()
        }
    
        if let hex = model?.fontColor {
            attributes[.foregroundColor] = UIColor(hex: hex)
        }
        
        if let underline = model?.isUnderlined, underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }
        
        return attributes
    }
}
