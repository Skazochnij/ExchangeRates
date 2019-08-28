//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

struct NetworkClient {
    fileprivate let requestPerformer: RequestPerformer

    public init(requestPerformer: RequestPerformer = NetworkRequestPerformer.shared) {
        self.requestPerformer = requestPerformer
    }
}

extension NetworkClient {
    func perform<T: Request>(_ request: T, completionHandler: @escaping (Result<T.ResponseObject, NetworkError>) -> Void) {
        do {
            let urlRequest = try request.build()

            requestPerformer.perform(urlRequest) { result in
                if let data = result.data {
                    if result.code == 200 {
                        do {
                            let object = try request.parse(jsonData: data)
                            completionHandler(.success(object))
                        } catch {
                            completionHandler(.failure(.parseError(error)))
                        }

                    } else {
                        completionHandler(.failure(.serverError(code: result.code, data: result.data)))
                    }
                } else if result.error != nil {
                    completionHandler(.failure(.serverError(code: result.code, data: result.error.debugDescription.data(using: .utf8))))
                }
            }
        } catch {
            print("Error \(error)")
        }
    }
}
