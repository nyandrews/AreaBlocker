import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var dailySummaryEnabled = true
    @State private var showAbout = false
    
    var body: some View {
        List {
            Section("🔔 NOTIFICATIONS") {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                Toggle("Daily Summary", isOn: $dailySummaryEnabled)
                    .disabled(!notificationsEnabled)
            }
            
            Section("📞 CALL DIRECTORY") {
                HStack {
                    Text("Status")
                    Spacer()
                    Text("Active")
                        .foregroundColor(.green)
                }
            }
            
            Section("ℹ️ ABOUT") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.secondary)
                }
                
                Button("About AreaBlocker") {
                    showAbout = true
                }
            }
            
            Section("🔒 PRIVACY") {
                Text("AreaBlocker respects your privacy. All data is stored locally on your device and is never shared with third parties.")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("About AreaBlocker")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("What is AreaBlocker?")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("AreaBlocker helps you block unwanted calls from specific area codes. Simply add the area codes you want to block, and AreaBlocker will automatically block calls from those regions.")
                        
                        Text("Key Features")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            FeatureRow(icon: "phone.fill", text: "Block calls by area code")
                            FeatureRow(icon: "list.bullet", text: "View call logs and statistics")
                            FeatureRow(icon: "bell.fill", text: "Get notifications about blocked calls")
                            FeatureRow(icon: "lock.fill", text: "Privacy-focused, data stays on your device")
                        }
                        
                        Text("Privacy First")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your data belongs to you. AreaBlocker stores all information locally on your device and never shares your personal information with third parties.")
                    }
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            Text(text)
            Spacer()
        }
    }
}

#Preview {
    SettingsView()
}
