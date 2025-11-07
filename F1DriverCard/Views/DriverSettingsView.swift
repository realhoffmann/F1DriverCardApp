import SwiftUI

struct DriverSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("favoriteDriverId") var favoriteDriverId: String = "max_verstappen"
    @ObservedObject var raceResultViewModel: RaceResultViewModel
    @StateObject var driversViewModel = DriversListViewModel()
    @StateObject var constructorsViewModel = ConstructorViewModel()
    @State private var selectedTeam: String = ""
    
    var filteredDrivers: [Driver] {
        driversViewModel.drivers(inTeam: selectedTeam)
    }
    
    var body: some View {
        VStack {
            List(filteredDrivers) { driver in
                HStack {
                    Text(driver.fullName)
                        .font(.f1Regular(16))
                        .foregroundColor(.white)
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
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
            
            Picker("Select Team", selection: $selectedTeam) {
                ForEach(constructorsViewModel.constructors, id: \.constructorId) { constructor in
                    Text(constructor.name)
                        .font(.f1Regular(16))
                        .foregroundColor(.white)
                        .tag(constructor.name)
                }
            }
            .pickerStyle(.wheel)
        }
        .onAppear {
            Task {
                await driversViewModel.fetchDrivers()
                await raceResultViewModel.fetchRaceData()
                await constructorsViewModel.fetchConstructors()
                await driversViewModel.updateTeamMapping(from: raceResultViewModel.getLastRaceForDriverMapping())
                if let team = driversViewModel.driverTeamMapping[favoriteDriverId] {
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
    DriverSettingsView(raceResultViewModel: RaceResultViewModel())
}
