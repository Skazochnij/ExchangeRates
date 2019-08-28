//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

struct NetworkRequestPerformer: RequestPerformer {
    static let shared = NetworkRequestPerformer()

    fileprivate let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }
}

extension NetworkRequestPerformer {
    @discardableResult
    func perform(_ request: URLRequest, completionHandler: @escaping (_ response: Response) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            let rawResponse = response as? HTTPURLResponse
            let object = Response(code: rawResponse?.statusCode ?? 500, data: data, error: error)
            completionHandler(object)
        }

        task.resume()
        return task
    }
}
