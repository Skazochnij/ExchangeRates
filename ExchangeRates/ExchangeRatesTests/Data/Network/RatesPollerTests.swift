//
//  RatesPollerTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 19/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class RatesPollerTests: XCTestCase {
    func testPolling() {
        guard
            let usd = Currency(from: "USD"),
            let eur = Currency(from: "EUR")
            else {
                return XCTFail("Currencies can't be nil")
        }
        
        let pair = Pair(base: usd, counter: eur)
        let fakePair = Pair(base: eur, counter: usd)
        let poller = RatesPoller()
        poller.add(pair)
        XCTAssertTrue(poller.polling, "Poller must start update rates after add currency")
        poller.remove(fakePair)
        XCTAssertTrue(poller.polling, "Poller must continue update rates after removing not existing pair")
        poller.remove(pair)
        XCTAssertFalse(poller.polling, "Poller must stop update rates after removing pair")
    }
}
