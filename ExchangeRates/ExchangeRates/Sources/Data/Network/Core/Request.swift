//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol Request {
    associatedtype ResponseObject

    func build() throws -> URLRequest
    func parse(jsonData: Data) throws -> ResponseObject
}
