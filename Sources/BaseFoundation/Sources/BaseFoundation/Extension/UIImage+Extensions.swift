//
//  File.swift
//  
//
//  Created by Eren Yürekli on 28.12.2022.
//

import UIKit

extension UIImage {
  public convenience init(color: UIColor, size: CGSize) {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    color.set()
    let ctx = UIGraphicsGetCurrentContext()!
    ctx.fill(CGRect(origin: .zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    self.init(data: image.pngData()!)!
  }
}
