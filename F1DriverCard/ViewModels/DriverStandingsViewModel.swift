import Foundation

class DriverStandingsViewModel: ObservableObject {
    @Published var championshipPosition: String = "N/A"
    
    func fetchDriverStandings(for driverId: String) async {
        let urlString = "https://ergast.com/api/f1/current/last/driverStandings.json"
        
        do {
            let response: DriverStandingsResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let standingsList = response.MRData.StandingsTable.StandingsLists.first?.DriverStandings {
                if let driverStanding = standingsList.first(where: { $0.Driver.driverId.lowercased() == driverId.lowercased() }) {
                    DispatchQueue.main.async {
                        self.championshipPosition = driverStanding.position
                    }
                } else {
                    DispatchQueue.main.async {
                        self.championshipPosition = "N/A"
                    }
                }
            }
        } catch {
            print("Error fetching driver standings: \(error)")
            DispatchQueue.main.async {
                self.championshipPosition = "N/A"
            }
        }
    }
}
