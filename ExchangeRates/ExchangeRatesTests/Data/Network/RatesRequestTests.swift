//
//  RatesRequestTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 18/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class RatesRequestTests: XCTestCase {
    func testOnePair() {
        guard
            let usd = Currency(from: "USD"),
            let eur = Currency(from: "EUR")
            else {
                return XCTFail("Currencies can't be nil")
        }
        let pair = Pair(base: usd, counter: eur)
        let request = RatesRequest(with: [pair])
        do {
            let urlRequest = try request.build()
            if let pairExist = urlRequest.url?.absoluteString.contains("\(usd.code)\(eur.code)") {
                XCTAssertTrue(pairExist, "Passed pair must exist in request url")
            }
        } catch {
            XCTFail("\(error)")
        }
    }
}
