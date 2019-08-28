//
//  ExchangeRateTableViewCell.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class ExchangeRateTableViewCellTests: XCTestCase {

    func testFilledRate() {
        guard let cell = ExchangeRateTableViewCell.loadFromNib() else {
            return XCTFail("Cell can't be nil")
        }

        guard
            let usd = Currency(from: "USD"),
            let eur = Currency(from: "EUR")
            else {
                return XCTFail("Currencies can't be nil")
        }
        let pair = Pair(base: usd, counter: eur)
        let rate = CurrencyRate(pair: pair, lastRate: 1.2453)
        cell.rate = rate

        if let label = cell.fromCurrency.text {
            XCTAssertTrue(label.contains(pair.base.code), "From currency code must contains \(pair.base.code)")
        }

        if var lastRate = rate.lastRate {
            var rounded: Decimal = Decimal()
            NSDecimalRound(&rounded, &lastRate, 4, .bankers)
            XCTAssertEqual(cell.toCurrency.attributedText?.string, "\(rounded)", "Rate for pair must be equal with passed")
        }
    }
}
