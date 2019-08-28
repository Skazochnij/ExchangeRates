//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import CoreData

protocol CoreDataWorkerProtocol {
    func get<Entity: ManagedObjectConvertible>(
        with predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        fetchLimit: Int?,
        completion: @escaping ([Entity]) -> Void)
    
    func upsert<Entity: ManagedObjectConvertible>(entities: [Entity], completion: @escaping (Error?) -> Void)
    func remove<Entity: ManagedObjectConvertible>(entity: Entity, completion: @escaping (Error?) -> Void)
}

extension CoreDataWorkerProtocol {
    func get<Entity: ManagedObjectConvertible>(
        with predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        fetchLimit: Int? = nil,
        completion: @escaping ([Entity]) -> Void) {
        get(with: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, completion: completion)
    }
}

class CoreDataWorker<ManagedEntity, Entity>: CoreDataWorkerProtocol where
    ManagedEntity: NSManagedObject,
    ManagedEntity: ManagedObjectProtocol,
    Entity: ManagedObjectConvertible {

    private let service: CoreDataServiceProtocol

    init(_ service: CoreDataServiceProtocol = CoreDataService.shared) {
        self.service = service
    }

    func get<Entity: ManagedObjectConvertible>(
        with predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor]?,
        fetchLimit: Int?,
        completion: @escaping ([Entity]) -> Void) {
        service.performBackgroundTask { context in
            do {
                let fetchRequest = self.universalFetchRequest()
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                if let fetchLimit = fetchLimit {
                    fetchRequest.fetchLimit = fetchLimit
                }
                let results = try context.fetch(fetchRequest) as? [ManagedEntity]
                let items: [Entity] = results?.compactMap { $0.toEntity() as? Entity } ?? []

                completion(items)
            } catch {
                print("Cannot fetch error: \(error)")
                completion([])
            }
        }
    }

    func getOne<Entity: ManagedObjectConvertible>(_ entity: Entity, from context: NSManagedObjectContext) -> ManagedEntity? {
        let fetchRequest = universalFetchRequest()
        fetchRequest.predicate = entity.uniquePredicate()
        do {
            let results = try context.fetch(fetchRequest) as? [ManagedEntity]
            return results?.first
        } catch {
            print("Error fetching one element: \(error)")
            return nil
        }
    }

    func upsert<Entity: ManagedObjectConvertible>(entities: [Entity], completion: @escaping (Error?) -> Void) {
        service.performBackgroundTask { context in
            _ = entities.compactMap({ (entity) -> Entity.ManagedObject? in
                return entity.toManagedObject(in: context)
            })

            if context.hasChanges {
                do {
                    try context.save()
                    completion(nil)
                } catch {
                    print("Cannot upsert, error: \(error)")
                    completion(error)
                }
            }
        }
    }

    func remove<Entity: ManagedObjectConvertible>(entity: Entity, completion: @escaping (Error?) -> Void) {
        service.performBackgroundTask { context in
            guard let managedEntity = self.getOne(entity, from: context) else {
                return
            }

            context.delete(managedEntity)
            if context.hasChanges {
                do {
                    try context.save()
                    completion(nil)
                } catch {
                    print("Can't delete, error: \(error)")
                    completion(error)
                }
            }
        }
    }

    func removeAll(completion: @escaping (Error?) -> Void) {
        service.performBackgroundTask { context in
            let fetch = self.universalFetchRequest()
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try context.execute(request)
                completion(nil)
            } catch {
                print("Can't deleteAll error: \(error)")
                completion(error)
            }

        }
    }

    private func universalFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        if #available(iOS 10.0, OSX 10.12, *) {
            fetchRequest = ManagedEntity.fetchRequest()
        } else {
            fetchRequest = NSFetchRequest(entityName: ManagedEntity.name)
        }

        return fetchRequest
    }
}
