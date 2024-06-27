//
//  File.swift
//  
//
//  Created by Eren Yürekli on 28.12.2022.
//

import UIKit

extension UISegmentedControl {
  
  public func removeBorder(){
    self.tintColor = UIColor.clear
    self.backgroundColor = UIColor.clear
    self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.red], for: .selected)
    self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
    if #available(iOS 13.0, *) {
      self.selectedSegmentTintColor = UIColor.clear
    }
  }
  
  public func setupSegment() {
    self.removeBorder()
    let segmentUnderlineWidth: CGFloat = self.bounds.width
    let segmentUnderlineHeight: CGFloat = 2.0
    let segmentUnderlineXPosition = self.bounds.minX
    let segmentUnderLineYPosition = self.bounds.size.height - 1.0
    let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
    let segmentUnderline = UIView(frame: segmentUnderlineFrame)
    segmentUnderline.backgroundColor = UIColor.clear
    self.addSubview(segmentUnderline)
    self.addUnderlineForSelectedSegment()
  }
  
  public func addUnderlineForSelectedSegment() {
    let underlineWidth: CGFloat = self.bounds.size.width / 1
    let underlineHeight: CGFloat = 2.0
    let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
    let underLineYPosition = self.bounds.size.height - 1.0
    let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
    let underline = UIView(frame: underlineFrame)
    underline.backgroundColor = UIColor.red
    underline.tag = 1
    self.addSubview(underline)
  }
  
  public func changeUnderlinePosition(){
    guard let underline = self.viewWithTag(1) else {return}
    let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
    underline.frame.origin.x = underlineFinalXPosition
  }
}
