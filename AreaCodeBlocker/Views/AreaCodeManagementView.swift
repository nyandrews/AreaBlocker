import SwiftUI

struct AreaCodeManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var areaCodeManager: AreaCodeManager
    @StateObject private var callManager: CallManager
    @State private var newAreaCode = ""
    @State private var showingAddSheet = false
    
    init() {
        let callManager = CallManager(context: PersistenceController.shared.container.viewContext)
        _callManager = StateObject(wrappedValue: callManager)
        _areaCodeManager = StateObject(wrappedValue: AreaCodeManager(context: PersistenceController.shared.container.viewContext, callManager: callManager))
    }
    
    var body: some View {
        List {
            if areaCodeManager.blockedAreaCodes.isEmpty {
                Section {
                    EmptyStateView()
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            } else {
                Section("📞 BLOCKED AREA CODES") {
                    ForEach(areaCodeManager.blockedAreaCodes) { areaCode in
                        AreaCodeRow(areaCode: areaCode) {
                            areaCodeManager.removeAreaCode(areaCode)
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Area Codes")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    showingAddSheet = true
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddAreaCodeSheet(areaCodeManager: areaCodeManager)
        }
    }
}

struct AreaCodeRow: View {
    let areaCode: AreaCode
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Area Code \(areaCode.code ?? "")")
                    .font(.headline)
                
                if let dateAdded = areaCode.dateAdded {
                    Text("Added \(dateAdded, style: .date)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button("Remove", role: .destructive) {
                onDelete()
            }
            .buttonStyle(.bordered)
        }
        .padding(.vertical, 4)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "phone.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Area Codes Blocked")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Add area codes to start blocking unwanted calls")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 40)
    }
}

struct AddAreaCodeSheet: View {
    @ObservedObject var areaCodeManager: AreaCodeManager
    @Environment(\.dismiss) private var dismiss
    @State private var newAreaCode = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Area Code") {
                    TextField("Enter 3-digit area code", text: $newAreaCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .onChange(of: newAreaCode) { newValue in
                            if newValue.count > 3 {
                                newAreaCode = String(newValue.prefix(3))
                            }
                        }
                }
                
                Section("Examples") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• 771 - Chicago area")
                        Text("• 773 - Chicago area")
                        Text("• 312 - Chicago area")
                    }
                    .font(.body)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Add Area Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !newAreaCode.isEmpty && newAreaCode.count == 3 {
                            areaCodeManager.addAreaCode(newAreaCode)
                            dismiss()
                        }
                    }
                    .disabled(newAreaCode.count != 3)
                }
            }
        }
    }
}

#Preview {
    AreaCodeManagementView()
}
