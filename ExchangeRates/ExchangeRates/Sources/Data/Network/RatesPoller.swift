//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol RatesPollerProtocol {
    var polling: Bool { get }
    var onRatedUpdated: ((_ rates: [String: Decimal]) -> Void)? { get set } 
    
    func add(_ pair: Pair)
    func remove(_ pair: Pair)
}

class RatesPoller: RatesPollerProtocol {
    var polling: Bool = false
    var onRatedUpdated: ((_ rates: [String: Decimal]) -> Void)?

    private var pairs: [Pair] = []
    private var rates: [String: Decimal]?
    private var workItem: DispatchWorkItem?

    private var queue = DispatchQueue(label: "network")

    func add(_ pair: Pair) {
        pairs.append(pair)

        if !pairs.isEmpty && !polling {
            startPollingRates()
        }
    }

    func remove(_ pair: Pair) {
        if let index = pairs.firstIndex(of: pair) {
            pairs.remove(at: index)
        }

        if pairs.isEmpty {
            stopPollingRates()
        }
    }

    private func startPollingRates() {
        if pairs.isEmpty {
            return
        }

        if workItem == nil {
            workItem = DispatchWorkItem(block: {
                let request = RatesRequest(with: self.pairs)
                NetworkClient().perform(request) { result in
                    switch result {
                    case .success(let rates):
                        self.rates = rates
                        self.onRatedUpdated?(rates)
                    case .failure(let error):
                        print("error \(error)")
                    }

                    if let workItem = self.workItem {
                        self.queue.asyncAfter(deadline: .now() + 1.0, execute: workItem)
                    }
                }
            })
        }

        workItem?.perform()
        polling = true
    }

    private func stopPollingRates() {
        if workItem != nil {
            workItem?.cancel()
            workItem = nil
            polling = false
        }
    }
}
