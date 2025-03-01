import SwiftUI

struct NavigationBarView: View {
    init() {
        // Set unselected tab icon color (using UIKit appearance)
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
    }
    
    var body: some View {
        TabView {
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            
            // Standings Tab (Placeholder for now)
            StandingsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
            
            // Settings Tab
            DriverSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
        .tint(.white)
    }
}
 // To be implemented
struct StandingsView: View {
    var body: some View {
        VStack {
            Text("Standings")
                .font(.largeTitle)
            Text("Coming soon...")
        }
    }
}

#Preview {
    NavigationBarView()
}
