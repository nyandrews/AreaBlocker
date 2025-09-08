import SwiftUI

struct CallLogView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var callManager: CallManager
    @State private var selectedFilter: CallFilter = .all
    
    init() {
        _callManager = StateObject(wrappedValue: CallManager(context: PersistenceController.shared.container.viewContext))
    }
    
    enum CallFilter: String, CaseIterable {
        case all = "All"
        case blocked = "Blocked"
        case allowed = "Allowed"
    }
    
    var body: some View {
        List {
            // Filter Picker
            Section {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(CallFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            if filteredCallLogs.isEmpty {
                Section {
                    EmptyCallLogView()
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            } else {
                Section("📞 CALL HISTORY") {
                    ForEach(filteredCallLogs) { callLog in
                        CallLogRow(callLog: callLog)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Call Log")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var filteredCallLogs: [CallLog] {
        switch selectedFilter {
        case .all:
            return callManager.callLogs
        case .blocked:
            return callManager.callLogs.filter { $0.isBlocked }
        case .allowed:
            return callManager.callLogs.filter { !$0.isBlocked }
        }
    }
}

struct CallLogRow: View {
    let callLog: CallLog
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(callLog.phoneNumber ?? "Unknown")
                    .font(.headline)
                
                if let areaCode = callLog.areaCode {
                    Text("Area Code: \(areaCode)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let timestamp = callLog.timestamp {
                    Text(timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: callLog.isBlocked ? "shield.fill" : "checkmark.circle.fill")
                    .foregroundColor(callLog.isBlocked ? .red : .green)
                
                Text(callLog.isBlocked ? "Blocked" : "Allowed")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(callLog.isBlocked ? .red : .green)
            }
        }
        .padding(.vertical, 4)
    }
}

struct EmptyCallLogView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Call Logs")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Call logs will appear here when calls are made")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 40)
    }
}

#Preview {
    CallLogView()
}
