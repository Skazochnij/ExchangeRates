//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

public enum NetworkError: Error {
    case badUrl(String)
    case parseError(Error)
    case serverError(code: Int, data: Data?)
    case urlSessionError(Error)
}

extension NetworkError: CustomNSError {
    public static let errorDomain = "com.revolut"

    public var errorCode: Int {
        switch self {
        case .parseError:
            return 1
        case .serverError:
            return 2
        case .urlSessionError:
            return 3
        case .badUrl:
            return 4
        }
    }

    #if !swift(>=3.1)
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        return userInfo
    }
    #endif
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .serverError(code, data):
            return message(forStatus: code, data: data)

        case let .parseError(error),
             let .urlSessionError(error):
            return (error as? LocalizedError).debugDescription
        case let .badUrl(url):
            return "Bad URL: \(url)"
        }
    }

    private func message(forStatus code: Int, data: Data?) -> String {
        switch code {
        case 300...399:
            return "Multiple choices: \(code)"
        case 400...499:
            if let data = data {
                return "Bad request: \(code), \(String(data: data, encoding: .utf8) ?? "")"
            } else {
                return "Bad request: \(code)"
            }
        case 500...599:
            return "Server error: \(code)"
        default:
            return "Unknown error: \(code)"
        }
    }
}
