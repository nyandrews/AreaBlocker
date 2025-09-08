import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data for previews
        let sampleAreaCode = AreaCode(context: viewContext)
        sampleAreaCode.code = "771"
        sampleAreaCode.isBlocked = true
        sampleAreaCode.dateAdded = Date()
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AreaCodeBlockerModel")
        
        // Optimize Core Data performance
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            // Configure store for better performance
            let storeDescription = container.persistentStoreDescriptions.first!
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            storeDescription.setOption(true as NSNumber, forKey: NSSQLitePragmasOption)
            
            // Set SQLite pragmas for better performance
            var pragmas: [String: String] = [:]
            pragmas["journal_mode"] = "WAL"
            pragmas["synchronous"] = "NORMAL"
            pragmas["cache_size"] = "1000"
            pragmas["temp_store"] = "MEMORY"
            storeDescription.setOption(pragmas as NSDictionary, forKey: NSSQLitePragmasOption)
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Optimize view context
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil // Disable undo for better performance
    }
}
