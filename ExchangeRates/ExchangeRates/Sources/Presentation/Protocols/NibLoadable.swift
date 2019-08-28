//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable where Self: UIResponder {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    static func loadFromNib() -> Self? {
        let bundle = Bundle(for: Self.self)
        guard let cell = bundle.loadNibNamed(nibName, owner: nil)?.first as? Self else {
            return nil
        }

        return cell
    }
}
