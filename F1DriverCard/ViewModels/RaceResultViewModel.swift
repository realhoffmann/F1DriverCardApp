import Foundation

@MainActor
class RaceResultViewModel: ObservableObject {
    @Published var race: Race?
    
    var trackImage: String {
        (race?.circuit.circuitId.lowercased() ?? "yas_marina") + "_track"
    }
    
    func fetchRaceResult(season: String = "2024", round: String = "last") async {
        let urlString = APIEndpoints.raceResults(season: season, round: round)
        do {
            let response: RaceResultResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let fetchedRace = response.mrData.raceTable.races.first {
                self.race = fetchedRace
            }
        } catch {
            print("Error fetching race result: \(error)")
        }
    }
    
    // Returns the result for the given driver ID if available.
    func resultForDriver(_ driverId: String) -> Result? {
        guard let race = race else {
            print("Race data is not available yet")
            return nil
        }
        if let result = race.results.first(where: { $0.driver.driverId.lowercased() == driverId.lowercased() }) {
            print("Found result for driver: \(result.driver.fullName), Position: \(result.position)")
            return result
        } else {
            print("No race result found for driverId: \(driverId)")
            print("Available drivers: \(race.results.map { $0.driver.driverId })")
            return nil
        }
    }
}
