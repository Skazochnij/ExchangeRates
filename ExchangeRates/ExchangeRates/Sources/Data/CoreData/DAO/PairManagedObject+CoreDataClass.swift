//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation
import CoreData

@objc(PairManagedObject)
public class PairManagedObject: NSManagedObject {

}

extension PairManagedObject: ManagedObjectProtocol {
    typealias Entity = CurrencyRate

    func toEntity() -> CurrencyRate? {
        guard
            let fromCurrency = Currency(from: base),
            let toCurrency = Currency(from: counter)
            else {
                return nil
        }
        return CurrencyRate(pair: Pair(base: fromCurrency, counter: toCurrency), lastRate: lastRate as Decimal?)
    }
}

extension CurrencyRate: ManagedObjectConvertible {
    typealias ManagedObject = PairManagedObject

    func toManagedObject(in context: NSManagedObjectContext) -> PairManagedObject? {
        guard let entity = NSEntityDescription.entity(forEntityName: "PairManagedObject", in: context) else { return nil }
        let managedObject = PairManagedObject(entity: entity, insertInto: context)

        managedObject.base = self.pair.base.code
        managedObject.counter = self.pair.counter.code
        managedObject.lastRate = self.lastRate as NSDecimalNumber?

        return managedObject
    }

    func uniquePredicate() -> NSPredicate {
        return NSPredicate(format: "base == %@ AND counter == %@", pair.base.code, pair.counter.code)
    }
}
