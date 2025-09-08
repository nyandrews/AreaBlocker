import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
            
            AreaCodeManagementView()
                .tabItem {
                    Image(systemName: "phone.fill")
                    Text("Area Codes")
                }
            
            CallLogView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Call Log")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(.blue)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    ContentView()
}
