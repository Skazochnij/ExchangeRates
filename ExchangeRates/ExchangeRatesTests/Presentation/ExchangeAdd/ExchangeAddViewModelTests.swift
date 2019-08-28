//
//  ExchangeAddViewModelTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class MockCurrenciesRepository: CurrenciesRepositoryProtocol {
    var currencies: [Currency]

    init(_ currencies: [Currency]) {
        self.currencies = currencies
    }
}

class ExchangeAddViewModelTests: XCTestCase {

    func testCorrectFill() {
        guard
            let usd = Currency(from: "USD"),
            let eur = Currency(from: "EUR")
            else {
                return XCTFail("Currencies can't be nil")
        }

        let repository = MockCurrenciesRepository([usd, eur])
        let viewModel = ExchangeAddViewModel(repository, [])

        XCTAssertEqual(viewModel.currencies.count, 2, "Some excess currencies in view model =/")
    }

    func testInvalidCurrencies() {
        guard
            let usd = Currency(from: "USD"),
            let eur = Currency(from: "EUR"),
            let rub = Currency(from: "RUB")
            else {
                return XCTFail("Currencies can't be nil")
        }

        let repository = MockCurrenciesRepository([usd, eur, rub])
        let viewModel = ExchangeAddViewModel(repository, [Pair(base: usd, counter: eur)], usd)

        XCTAssertEqual(viewModel.inactiveCurrencies.count, 2, "Some excess currencies in view model =/")
    }
}
