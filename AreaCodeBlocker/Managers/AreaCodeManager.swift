import Foundation
import CoreData

class AreaCodeManager: ObservableObject {
    @Published var blockedAreaCodes: [AreaCode] = []
    @Published var isLoading = false
    
    private let viewContext: NSManagedObjectContext
    private weak var callManager: CallManager?
    private var hasLoaded = false
    
    init(context: NSManagedObjectContext, callManager: CallManager? = nil) {
        self.viewContext = context
        self.callManager = callManager
        // Don't fetch immediately - use lazy loading
    }
    
    func setCallManager(_ callManager: CallManager) {
        self.callManager = callManager
    }
    
    func loadDataIfNeeded() {
        guard !hasLoaded else { return }
        hasLoaded = true
        fetchAreaCodes()
    }
    
    func fetchAreaCodes() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let request: NSFetchRequest<AreaCode> = AreaCode.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \AreaCode.code, ascending: true)]
            
            do {
                let results = try self.viewContext.fetch(request)
                DispatchQueue.main.async {
                    self.blockedAreaCodes = results
                    self.isLoading = false
                }
            } catch {
                print("Error fetching area codes: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    func addAreaCode(_ code: String) {
        let newAreaCode = AreaCode(context: viewContext)
        newAreaCode.code = code
        newAreaCode.isBlocked = true
        newAreaCode.dateAdded = Date()
        
        do {
            try viewContext.save()
            fetchAreaCodes()
            // Automatically reload call directory when new area code is added
            callManager?.reloadCallDirectory()
        } catch {
            print("Error saving area code: \(error)")
        }
    }
    
    func removeAreaCode(_ areaCode: AreaCode) {
        viewContext.delete(areaCode)
        
        do {
            try viewContext.save()
            fetchAreaCodes()
            // Automatically reload call directory when area code is removed
            callManager?.reloadCallDirectory()
        } catch {
            print("Error deleting area code: \(error)")
        }
    }
    
    func isAreaCodeBlocked(_ code: String) -> Bool {
        return blockedAreaCodes.contains { $0.code == code }
    }
}
