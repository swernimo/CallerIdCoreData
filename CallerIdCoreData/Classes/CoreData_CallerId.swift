//shameless copied from https://medium.com/@pietromessineo/ios-share-coredata-with-extension-and-app-groups-69f135628736
import Foundation
import CoreData

public class CoreData_CallerId {
    public static let shared = CoreData_CallerId()
    private let groupName: String = "group.com.unanet.cosentialformobile"
    private static let entityName: String = "CallerInfo"
    private static let modelName: String = "CallerIdModel"
  
    public var persistentContainer: NSPersistentContainer? = {
      let modelURL = Bundle(for: CoreData_CallerId.self).url(forResource: modelName, withExtension: "momd")
      var container: NSPersistentContainer
      
      guard let model = modelURL.flatMap(NSManagedObjectModel.init) else {
        print("Fail to load the trigger model!")
        return nil
      }
      
      container = NSPersistentContainer(name: modelName, managedObjectModel: model)
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
          print("Unresolved error \(error), \(error.userInfo)")
        }
      })
      
      return container
    }()
    
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let storeURL = URL.storeURL(for: groupName, databaseName: modelName)
//        let storeDescription = NSPersistentStoreDescription(url: storeURL)
//        let container = NSPersistentContainer(name: modelName)
//        container.persistentStoreDescriptions = [storeDescription]
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
    
    public func getCallerInfoArray() -> [CallerInfo] {
        var callers: [CallerInfo] = []
        do {
            guard let context = CoreData_CallerId.shared.persistentContainer?.viewContext else { return callers}
            let fetchRequest = NSFetchRequest<CallerInfo>(entityName: CoreData_CallerId.entityName)
            let result = try context.fetch(fetchRequest)
            if !result.isEmpty {
                callers = result
            }
        } catch let error as NSError {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return callers
    }
    
    public func saveContext() {
        guard let context = CoreData_CallerId.shared.persistentContainer?.viewContext else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
