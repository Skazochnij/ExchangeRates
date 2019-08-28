//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol RequestPerformer {
    @discardableResult
    func perform(_ request: URLRequest, completionHandler: @escaping (_ response: Response) -> Void) -> URLSessionDataTask
}
