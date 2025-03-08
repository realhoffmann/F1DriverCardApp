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
                print("Fetched race: \(fetchedRace.raceName)")
                print("Circuit ID: \(fetchedRace.circuit.circuitId)")
                self.race = fetchedRace
            }
        } catch {
            print("Error fetching race result: \(error)")
        }
    }
    
    // Fetches the previous race result by decrementing the current round number.
    func fetchPreviousRaceResult(season: String = "2024") async {
        if let currentRace = race,
           let currentRoundInt = Int(currentRace.round),
           currentRoundInt > 1 {
            let previousRound = String(currentRoundInt - 1)
            await fetchRaceResult(season: season, round: previousRound)
        } else {
            print("Cannot load previous race: current race is not set or round is invalid")
        }
    }
    
    // Fetches the next race result by incrementing the current round number.
    func fetchNextRaceResult(season: String = "2024") async {
        if let currentRace = race,
           let currentRoundInt = Int(currentRace.round) {
            let nextRound = String(currentRoundInt + 1)
            await fetchRaceResult(season: season, round: nextRound)
        } else {
            print("Cannot load next race: current race is not set or round is invalid")
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
