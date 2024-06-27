//
//  UITableView+Extensions.swift
//  BaseFoundation
//
//  Created by Talip on 15.11.2022.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
              "Failed to dequeue a table cell with identifier \(withClass.reuseIdentifier) matching type \(withClass.self). "
              + "Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand."
            )
        }
        return cell
    }
    
    func register<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
}
