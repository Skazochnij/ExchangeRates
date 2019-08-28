//
//  CurrencyTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class CurrencyTests: XCTestCase {
    func testValidCurrency() {
        XCTAssertNotNil(Currency(from: "EUR"), "Currency from valid ISO4217 code must not be nil")
    }

    func testInvalidCurrency() {
        XCTAssertNil(Currency(from: "ZZZ"), "Currency from invalid ISO4217 code must be nil")
    }
}
