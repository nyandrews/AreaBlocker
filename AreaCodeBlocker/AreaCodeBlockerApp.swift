import SwiftUI

@main
struct AreaCodeBlockerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            } else {
                NavigationView {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}
