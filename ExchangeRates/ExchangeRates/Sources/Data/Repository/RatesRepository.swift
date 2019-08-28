//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

class RatesRepository: ManagedRepositoryProtocol {
    typealias Entity = CurrencyRate

    var worker: CoreDataWorker<PairManagedObject, CurrencyRate>

    init(_ worker: CoreDataWorker<PairManagedObject, CurrencyRate>) {
        self.worker = worker
    }
}
