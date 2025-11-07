import SwiftUI

struct NavigationBarView: View {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var raceScheduleVM = RaceScheduleViewModel()
    @StateObject private var raceResultVM = RaceResultViewModel()
    @StateObject private var driverStandingsVM = DriverStandingsViewModel()
    @StateObject private var qualifyingVM = QualifyingViewModel()
    init() {
        // Set unselected tab icon color (using UIKit appearance)
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
    }
    
    var body: some View {
        TabView {
            HomeView(
                viewModel: homeVM,
                raceResultViewModel: raceResultVM,
                raceScheduleViewModel: raceScheduleVM,
                driverStandingsViewModel: driverStandingsVM,
                qualifyingViewModel: qualifyingVM
            )
                .tabItem {
                    Image(systemName: "house.fill")
                }
            
            StandingsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                }
            
            DriverSettingsView(raceResultViewModel: raceResultVM)
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
