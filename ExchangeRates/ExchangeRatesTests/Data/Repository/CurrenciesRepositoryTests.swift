//
//  CurrenciesRepositoryTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class CurrenciesRepositoryTests: XCTestCase {
    func testLoadingCurrencies() {
        let repository = CurrenciesRepository(fromPath: "currencies", ofType: "json")
        XCTAssertFalse(repository.currencies.isEmpty, "List of currencies must not be empty")
    }

    func testLoadingWrongFilePath() {
        let repository = CurrenciesRepository(fromPath: UUID().uuidString, ofType: "json")
        XCTAssertTrue(repository.currencies.isEmpty, "List of currencies must be empty")
    }

    func testLoadingWrongFileFormat() {
        let repository = CurrenciesRepository(fromPath: "Info", ofType: "plist")
        XCTAssertTrue(repository.currencies.isEmpty, "List of currencies must be empty")
    }
}
