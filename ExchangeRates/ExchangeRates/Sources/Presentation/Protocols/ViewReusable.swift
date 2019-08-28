//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import UIKit

protocol ViewReusable: class {
    static var defaultReuseIdentifier: String { get }
}

extension ViewReusable where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
