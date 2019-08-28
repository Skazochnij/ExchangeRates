//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import Foundation

protocol ManagedRepositoryProtocol where Entity: ManagedObjectConvertible {
    associatedtype Entity

    var worker: CoreDataWorker<Entity.ManagedObject, Entity> { get }

    func upsert(entity: Entity, completion: @escaping (Error?) -> Void)
    func get(_ completion: @escaping([Entity]) -> Void)
    func remove(_ entity: Entity, completion: @escaping(Error?) -> Void)
    func removeAll(completion: @escaping (Error?) -> Void)
}

extension ManagedRepositoryProtocol {
    func upsert(entity: Entity, completion: @escaping (Error?) -> Void) {
        self.upsert(entities: [entity], completion: completion)
    }

    func upsert(entities: [Entity], completion: @escaping (Error?) -> Void) {
        worker.upsert(entities: entities) { (error) in
            completion(error)
        }
    }

    func get(_ completion: @escaping ([Entity]) -> Void) {
        worker.get { (items) in
            completion(items)
        }
    }

    func remove(_ entity: Entity, completion: @escaping (Error?) -> Void) {
        worker.remove(entity: entity, completion: completion)
    }

    func removeAll(completion: @escaping (Error?) -> Void) {
        worker.removeAll(completion: completion)
    }
}
