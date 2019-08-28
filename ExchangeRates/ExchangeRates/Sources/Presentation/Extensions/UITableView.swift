//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ViewReusable, T: NibLoadable {
        let bundle = Bundle(for: T.self)

        let nib = UINib(nibName: T.nibName, bundle: bundle)

        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ViewReusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Couldn't dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
}
