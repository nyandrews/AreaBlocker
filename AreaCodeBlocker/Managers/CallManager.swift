import Foundation
import CoreData
import CallKit

class CallManager: ObservableObject {
    @Published var callLogs: [CallLog] = []
    @Published var isLoading = false
    
    private let viewContext: NSManagedObjectContext
    private let callDirectoryManager = CXCallDirectoryManager.sharedInstance
    private var hasLoaded = false
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        // Don't fetch immediately - use lazy loading
    }
    
    func loadDataIfNeeded() {
        guard !hasLoaded else { return }
        hasLoaded = true
        fetchCallLogs()
    }
    
    func fetchCallLogs() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let request: NSFetchRequest<CallLog> = CallLog.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \CallLog.timestamp, ascending: false)]
            
            do {
                let results = try self.viewContext.fetch(request)
                DispatchQueue.main.async {
                    self.callLogs = results
                    self.isLoading = false
                }
            } catch {
                print("Error fetching call logs: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    func logCall(phoneNumber: String, isBlocked: Bool) {
        let callLog = CallLog(context: viewContext)
        callLog.phoneNumber = phoneNumber
        callLog.areaCode = String(phoneNumber.prefix(3))
        callLog.isBlocked = isBlocked
        callLog.timestamp = Date()
        
        do {
            try viewContext.save()
            fetchCallLogs()
        } catch {
            print("Error saving call log: \(error)")
        }
    }
    
    func reloadCallDirectory() {
        callDirectoryManager.reloadExtension(withIdentifier: "com.areacodeblocker.AreaCodeBlocker.AreaCodeBlockerExtension") { error in
            if let error = error {
                print("Error reloading call directory: \(error)")
            } else {
                print("Call directory reloaded successfully")
            }
        }
    }
}
