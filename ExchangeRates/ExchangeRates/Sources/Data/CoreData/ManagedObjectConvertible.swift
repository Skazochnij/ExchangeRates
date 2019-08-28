//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import CoreData

protocol ManagedObjectConvertible {
    associatedtype ManagedObject: NSManagedObject, ManagedObjectProtocol
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
    func uniquePredicate() -> NSPredicate
}
