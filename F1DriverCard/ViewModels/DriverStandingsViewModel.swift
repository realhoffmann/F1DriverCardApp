import Foundation

@MainActor
class DriverStandingsViewModel: ObservableObject {
    @Published var championshipPosition: String = "N/A"
    
    func fetchDriverStandings(for driverId: String, round: String = "last") async {
        let urlString = APIEndpoints.driverStandings(round: round)
        do {
            let response: DriverStandingsResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let standingsList = response.mrData.standingsTable.standingsLists.first?.driverStandings,
               let driverStanding = standingsList.first(where: { $0.driver.driverId.lowercased() == driverId.lowercased() }) {
                self.championshipPosition = driverStanding.position ?? "N/A"
            } else {
                self.championshipPosition = "N/A"
            }
        } catch {
            print("Error fetching driver standings: \(error)")
            self.championshipPosition = "N/A"
        }
    }
}
