import SwiftUI
import SharedKit

struct ContentView: View {
    @StateObject private var dreamStore = DreamStore()
    
    var body: some View {
        TabView {
            NavigationView {
                DreamProgressView()
            }
            .tabItem {
                Label("进度", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            NavigationView {
                DreamSettingsView(isNewDream: false)
            }
            .tabItem {
                Label("设置", systemImage: "gearshape")
            }
            
            NavigationView {
                DreamWidgetView()
            }
            .tabItem {
                Label("小组件", systemImage: "app.badge")
            }
        }
        .environmentObject(dreamStore)
    }
} 