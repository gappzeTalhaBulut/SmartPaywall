//
//  ReuseIdentifier.swift
//  BaseFoundation
//
//  Created by Talip on 25.03.2022.
//

import UIKit

protocol ReuseIdentifiable: AnyObject {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReuseIdentifiable {}
extension UICollectionViewCell: ReuseIdentifiable {}

