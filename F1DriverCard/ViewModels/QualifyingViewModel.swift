import Foundation

@MainActor
class QualifyingViewModel: ObservableObject {
    @Published var qualifyingRace: QualifyingRace?
    @Published var qualifyingPosition: String = "N/A"
    @Published var lapTime: String = "N/A"
    
    func fetchQualifyingResult(for driverId: String, season: String = "2024", round: String = "last") async {
        let urlString = APIEndpoints.qualifying(season: season, round: round)
        do {
            let response: QualifyingResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let race = response.mrData.raceTable.races.first,
               let result = race.qualifyingResults.first(where: { $0.driver.driverId.lowercased() == driverId.lowercased() }) {
                self.qualifyingPosition = result.position
                self.lapTime = result.q3 ?? result.q2 ?? result.q1 ?? "N/A"
            } else {
                self.qualifyingPosition = "N/A"
            }
        } catch {
            print("Error fetching qualifying data: \(error)")
            self.qualifyingPosition = "N/A"
        }
    }
}
