//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

struct Pair {
    let base: Currency
    let counter: Currency
}

extension Pair: Equatable {
    static func == (lhs: Pair, rhs: Pair) -> Bool {
        return lhs.base == rhs.base && lhs.counter == rhs.counter
    }
}
