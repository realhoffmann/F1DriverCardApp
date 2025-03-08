import SwiftUI

struct NavigationBarView: View {
    init() {
        // Set unselected tab icon color (using UIKit appearance)
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
            
            StandingsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
            
            DriverSettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
        }
        .tint(.white)
    }
}

// Placeholder for future implementation
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
