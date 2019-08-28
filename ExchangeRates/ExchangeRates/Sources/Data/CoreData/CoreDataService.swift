//
//  ExchangeRates
//  Created by Aleksey Kornienko
//

import CoreData

protocol CoreDataServiceProtocol {
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class CoreDataService: CoreDataServiceProtocol {
    static let shared = CoreDataService()
    private let modelName: String = "ExchangeRates"

    private lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.modelName.appending(".sqlite"))
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(
                    ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: url,
                    options: [
                        NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true
                    ]
            )
        } catch {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error as NSError

            let wrappedError = NSError(domain: "com.revolut.ios", code: 0, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }

        return coordinator
    }()

    private lazy var parentObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return managedObjectContext
    }()

    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentStoreCoordinator.performAndWait {
            block(self.parentObjectContext)
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentStoreCoordinator.perform {
            block(self.parentObjectContext)
        }
    }
}
