import Foundation
import CoreData
import SwiftUI

class AppManager: ObservableObject {
    static let shared = AppManager()
    
    @Published var areaCodeManager: AreaCodeManager
    @Published var callManager: CallManager
    
    private init() {
        let context = PersistenceController.shared.container.viewContext
        self.callManager = CallManager(context: context)
        self.areaCodeManager = AreaCodeManager(context: context, callManager: callManager)
    }
    
    func loadInitialData() {
        // Load data in background to avoid blocking UI
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.areaCodeManager.loadDataIfNeeded()
                self.callManager.loadDataIfNeeded()
            }
        }
    }
}
