//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol ExchangeRatesProtocol: class {
    func pairDidAdded()
    func pairDidRemoved(at index: Int)
    func ratesDidUpdated(_ rates: [String: Decimal])
}

protocol ExchangeRatesViewModelProtocol {
    var rates: [CurrencyRate] { get }

    var delegate: ExchangeRatesProtocol? { get set }

    func addPair(_ base: Currency, _ counter: Currency)

    func removePair(at index: Int)
}

final class ExchangeRatesViewModel: ExchangeRatesViewModelProtocol {
    weak var delegate: ExchangeRatesProtocol?

    var rates: [CurrencyRate] = []

    private var poller: RatesPollerProtocol
    private let repository: RatesRepository

    init(_ repository: RatesRepository) {
        self.poller = RatesPoller()
        self.repository = repository

        self.poller.onRatedUpdated = { [weak self] rates in
            self?.delegate?.ratesDidUpdated(rates)
        }

        self.repository.get { [weak self] rates in
            self?.rates = rates.reversed()
            rates.forEach({ rate in
                let pair = Pair(base: rate.pair.base, counter: rate.pair.counter)
                self?.poller.add(pair)
            })
        }
    }

    func addPair(_ base: Currency, _ counter: Currency) {
        let pair = Pair(base: base, counter: counter)
        let currencyRate = CurrencyRate(pair: pair, lastRate: nil)
        repository.upsert(entity: currencyRate) { _ in
            self.rates.insert(currencyRate, at: 0)
            self.poller.add(pair)
            self.delegate?.pairDidAdded()
        }
    }

    func removePair(at index: Int) {
        let rate = rates[index]
        let pair = Pair(base: rate.pair.base, counter: rate.pair.counter)
        repository.remove(rate) { (_) in
            self.rates.remove(at: index)
            self.poller.remove(pair)
            self.delegate?.pairDidRemoved(at: index)
        }
    }
}
