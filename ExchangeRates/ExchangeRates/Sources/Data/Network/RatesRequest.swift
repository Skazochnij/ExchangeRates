//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

struct RatesRequest: Request {
    typealias ResponseObject = [String: Decimal]

    private let pairs: [Pair]

    init(with pairs: [Pair]) {
        self.pairs = pairs
    }

    func build() throws -> URLRequest {
        let parameters = "?pairs=" + pairs.map { "\($0.base.code)\($0.counter.code)" }.joined(separator: "&pairs=")
        let urlString = "https://europe-west1-revolut-230009.cloudfunctions.net/revolut-ios\(parameters)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.badUrl(urlString)
        }

        return URLRequest(url: url)
    }

    func parse(jsonData: Data) throws -> [String: Decimal] {
        return try JSONDecoder().decode([String: Decimal].self, from: jsonData)
    }
}
