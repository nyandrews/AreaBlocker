import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var areaCodeManager: AreaCodeManager
    @StateObject private var callManager: CallManager
    
    init() {
        // This will be set by the environment
        let callManager = CallManager(context: PersistenceController.shared.container.viewContext)
        _callManager = StateObject(wrappedValue: callManager)
        _areaCodeManager = StateObject(wrappedValue: AreaCodeManager(context: PersistenceController.shared.container.viewContext, callManager: callManager))
    }
    
    var body: some View {
        List {
            // MARK: - Header Section
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("AreaBlocker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text("Stop unwanted call and text notifications")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            
            // MARK: - Daily Log Section
            Section("📋 DAILY LOG") {
                HStack {
                    Image(systemName: "list.bullet")
                        .foregroundColor(.green)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calls Blocked Today")
                            .font(.headline)
                        Text("\(callsBlockedToday)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            
            // MARK: - Blocked Calls Section
            Section("📞 BLOCKED CALLS") {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.red)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Blocked Area Codes")
                            .font(.headline)
                        Text("\(areaCodeManager.blockedAreaCodes.count)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Dashboard")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            areaCodeManager.loadDataIfNeeded()
            callManager.loadDataIfNeeded()
        }
    }
    
    private var callsBlockedToday: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return callManager.callLogs.filter { callLog in
            guard let timestamp = callLog.timestamp else { return false }
            return callLog.isBlocked && timestamp >= today
        }.count
    }
    
}


#Preview {
    DashboardView()
}
