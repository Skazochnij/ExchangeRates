//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol CurrenciesRepositoryProtocol {
    var currencies: [Currency] { get }
}

final class CurrenciesRepository: CurrenciesRepositoryProtocol {
    var currencies: [Currency]

    init(fromPath path: String, ofType fileType: String) {
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: path, ofType: fileType) else {
            currencies = []
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let isoCodes = try JSONDecoder().decode([String].self, from: data)
            currencies = isoCodes.compactMap { Currency(from: $0) }
        } catch {
            currencies = []
        }
    }
}
