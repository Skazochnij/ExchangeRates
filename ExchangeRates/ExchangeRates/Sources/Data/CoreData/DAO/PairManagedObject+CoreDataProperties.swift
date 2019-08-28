//
//  ExchangeRates
//  Created by Aleksey Kornienko
//
//

import Foundation
import CoreData

extension PairManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PairManagedObject> {
        return NSFetchRequest<PairManagedObject>(entityName: "PairManagedObject")
    }

    @NSManaged public var base: String
    @NSManaged public var counter: String
    @NSManaged public var lastRate: NSDecimalNumber?
}
