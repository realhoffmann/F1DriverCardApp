import SwiftUI

struct DriverSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("favoriteDriverId") var favoriteDriverId: String = "max_verstappen"
    @StateObject var driversViewModel = DriversListViewModel()
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @StateObject var constructorsViewModel = ConstructorViewModel()
    @State private var selectedTeam: String = ""
    
    var driverTeamMapping: [String: String] {
        guard let race = raceResultViewModel.race else { return [:] }
        var mapping = [String: String]()
        for result in race.results {
            mapping[result.driver.driverId] = result.constructor.name
        }
        return mapping
    }
    
    var filteredDrivers: [Driver] {
        driversViewModel.drivers.filter { driver in
            if let team = driverTeamMapping[driver.driverId] {
                return team == selectedTeam
            }
            return false
        }
    }
    
    var body: some View {
        VStack {
            // Dropdown to select a team using the constructors list
            Picker("Select Team", selection: $selectedTeam) {
                ForEach(constructorsViewModel.constructors, id: \.constructorId) { constructor in
                    Text(constructor.name).tag(constructor.name)
                }
            }
            .pickerStyle(.menu)
            .padding()
            
            // List the drivers filtered by the selected team
            List(filteredDrivers) { driver in
                HStack {
                    Text(driver.fullName)
                    Spacer()
                    if driver.driverId == favoriteDriverId {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    favoriteDriverId = driver.driverId
                    dismiss()
                }
            }
        }
        .onAppear {
            Task {
                await driversViewModel.fetchDrivers()
                await raceResultViewModel.fetchRaceResult()
                await constructorsViewModel.fetchConstructors()
                if let team = driverTeamMapping[favoriteDriverId] {
                    selectedTeam = team
                } else if selectedTeam.isEmpty,
                          let firstConstructor = constructorsViewModel.constructors.first {
                    selectedTeam = firstConstructor.name
                }
            }
        }
    }
}

#Preview {
    DriverSettingsView()
}
