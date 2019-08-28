//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol ExchangeAddViewModelProtocol {
    var title: String { get }

    var pairs: [Pair] { get }

    var selectedCurrency: Currency? { get }

    var currencies: [Currency] { get }
    var inactiveCurrencies: [Currency] { get }
}

final class ExchangeAddViewModel: ExchangeAddViewModelProtocol {
    var title: String {
        return (selectedCurrency != nil) ? "Select second currency" : "Select first currency"
    }

    var pairs: [Pair]

    var selectedCurrency: Currency?

    var currencies: [Currency]
    var inactiveCurrencies: [Currency]

    init(_ repository: CurrenciesRepositoryProtocol, _ pairs: [Pair], _ selected: Currency? = nil) {
        self.pairs = pairs
        self.currencies = repository.currencies
        self.selectedCurrency = selected

        self.inactiveCurrencies = []

        if let currency = selected {
            inactiveCurrencies.append(currency)
            inactiveCurrencies.append(contentsOf: pairs.filter { $0.base.code == currency.code }.map { $0.counter })
        }
    }
}
