//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

struct Currency: Equatable {
    let code: String
    let name: String

    init?(from code: String) {
        guard let name = Locale.current.localizedString(forCurrencyCode: code) else {
            return nil
        }

        self.code = code
        self.name = name
    }
}
