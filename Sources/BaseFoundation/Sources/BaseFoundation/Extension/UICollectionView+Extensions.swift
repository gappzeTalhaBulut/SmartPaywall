//
//  Created by Eren Yürekli on 19.12.2022.
//
//

import UIKit

extension UICollectionView {
    public func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(withClass: T.Type, for indexPath: IndexPath) -> T {
      guard let cell = dequeueReusableCell(withReuseIdentifier: withClass.reuseIdentifier, for: indexPath) as? T else {
        fatalError(
          "Failed to dequeue a collection cell with identifier \(withClass.reuseIdentifier) matching type \(withClass.self). "
          + "Check that the reuseIdentifier is set properly in your XIB/Storyboard and that you registered the cell beforehand."
        )
      }
      return cell
    }
}
