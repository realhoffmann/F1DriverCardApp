import Foundation

@MainActor
class DriversListViewModel: ObservableObject {
    @Published var drivers: [Driver] = []
    @Published var driverTeamMapping: [String: String] = [:]
    
    func fetchDrivers() async {
        do {
            let response: DriverResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.drivers)
            self.drivers = response.mrData.driverTable.drivers
        } catch {
            print("Error fetching drivers list: \(error)")
        }
    }
    
    func updateTeamMapping(from race: Race?) {
        guard let race else {
            driverTeamMapping = [:]
            return
        }
        driverTeamMapping = Dictionary(uniqueKeysWithValues: race.results.map {
            ($0.driver.driverId, $0.constructor.name)
        })
    }
    
    func drivers(inTeam team: String) -> [Driver] {
        drivers.filter { driverTeamMapping[$0.driverId] == team }
    }
}
