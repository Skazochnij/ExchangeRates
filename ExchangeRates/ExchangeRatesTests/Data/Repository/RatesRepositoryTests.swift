//
//  RatesRepositoryTests.swift
//  ExchangeRatesTests
//
//  Created by Aleksey Kornienko on 17/08/2019.
//  Copyright © 2019 Aleksey Kornienko. All rights reserved.
//

import XCTest
@testable import ExchangeRates

class RatesRepositoryTests: XCTestCase {
    private let repository = RatesRepository(CoreDataWorker<PairManagedObject, CurrencyRate>())

    private var testRate: CurrencyRate? {
        guard
            let usd = Currency(from: "USD"),
            let rub = Currency(from: "RUB")
            else {
                XCTFail("Currencies must not be nil")
                return nil
        }

        let pair = Pair(base: usd, counter: rub)
        return CurrencyRate(pair: pair, lastRate: 1.0)
    }

    override func setUp() {
        repository.removeAll { _ in }
    }

    func testInsertRate() {
        guard let rate = testRate else { return }
        repository.get { (before) in
            self.repository.upsert(entity: rate, completion: { (error) in
                if let error = error {
                    XCTAssertNil(error, "Error while inserting entity: \(error)")
                }

                self.repository.get({ after in
                    XCTAssertEqual(before.count + 1, after.count, "Count of entries after inserting must be +1")
                })
            })
        }
    }

    func testRemoveRate() {
        guard let rate = testRate else { return }
        repository.upsert(entity: rate) { (error) in
            if let error = error {
                XCTAssertNil(error, "Error while inserting entity: \(error)")
            }

            self.repository.remove(rate, completion: { (error) in
                if let error = error {
                    XCTAssertNil(error, "Error while removing entity: \(error)")
                }
            })
        }
    }
}
