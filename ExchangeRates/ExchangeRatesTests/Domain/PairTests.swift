//
//  PairTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class PairTests: XCTestCase {
    func testEquals() {
        guard
            let usd = Currency(from: "USD"),
            let eur = Currency(from: "EUR")
        else {
            XCTFail("Currencies must not be nil")
            return
        }

        let firstPair = Pair(base: usd, counter: eur)
        let secondPair = firstPair
        let thirdPair = Pair(base: usd, counter: eur)

        XCTAssertEqual(firstPair, secondPair, "Pairs with same currencies must be equal")
        XCTAssertEqual(firstPair, thirdPair, "Pairs with same currencies must be equal")
    }

    func testNotEquals() {
        guard
            let usd = Currency(from: "USD"),
            let rub = Currency(from: "RUB")
            else {
                XCTFail("Currencies must not be nil")
                return
        }

        let firstPair = Pair(base: usd, counter: rub)
        let secondPair = Pair(base: rub, counter: usd)

        XCTAssertNotEqual(firstPair, secondPair, "Pairs with different currencies must not be equal")
    }
}
