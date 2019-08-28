//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import CoreData

protocol ManagedObjectProtocol {
    associatedtype Entity

    func toEntity() -> Entity?
}
