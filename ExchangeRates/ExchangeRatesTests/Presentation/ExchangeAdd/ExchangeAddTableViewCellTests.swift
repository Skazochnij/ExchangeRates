//
//  ExchangeAddTableViewCellTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class ExchangeAddTableViewCellTests: XCTestCase {
    func testValidCurrency() {
        guard let currency = Currency(from: "USD") else {
            return XCTFail("Currency can't be nil")
        }

        guard let cell = ExchangeAddTableViewCell.loadFromNib() else {
            return XCTFail("Cell can't be nil")
        }
        cell.currency = currency

        XCTAssertEqual(cell.code.text, currency.code, "Cell code text must be equal with currency code")
        XCTAssertEqual(cell.name.text, currency.name, "Cell name text must be equal with currency name")
    }

    func testNilCurrency() {
        guard let cell = ExchangeAddTableViewCell.loadFromNib() else {
            return XCTFail("Cell can't be nil")
        }
        cell.currency = nil

        XCTAssertNil(cell.code.text, "Cell code text must be nil")
        XCTAssertNil(cell.name.text, "Cell name text must be nil")
        XCTAssertNil(cell.flag.image, "Cell flag must be nil")
    }

    func testIsActive() {
        guard let cell = ExchangeAddTableViewCell.loadFromNib() else {
            return XCTFail("Cell can't be nil")
        }
        cell.isActive = true
        XCTAssertEqual(cell.selectionStyle, .blue, "Selection style must be nil when cell is inactive")
        cell.isActive = false
        XCTAssertEqual(cell.selectionStyle, .none, "Selection style must be blue when cell is active")
    }
}
