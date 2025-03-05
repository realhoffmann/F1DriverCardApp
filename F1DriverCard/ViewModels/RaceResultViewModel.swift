import Foundation

class RaceResultViewModel: ObservableObject {
    @Published var race: Race?
    
    func fetchRaceResult() async {
        // TODO: change 2024 to current once season starts
        let urlString = "https://api.jolpi.ca/ergast/f1/2024/last/results.json"
        do {
            let response: RaceResultResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let fetchedRace = response.MRData.RaceTable.Races.first {
                DispatchQueue.main.async {
                    self.race = fetchedRace
                }
            }
        } catch {
            print("Error fetching race result: \(error)")
        }
    }
    
    /// Returns the result for the given driver ID if available.
    func resultForDriver(_ driverId: String) -> Result? {
        guard let race = race else {
            print("Race data is not available yet")
            return nil
        }
        
        let lowercasedDriverId = driverId.lowercased()
        if let result = race.Results.first(where: { $0.Driver.driverId.lowercased() == lowercasedDriverId }) {
            print("Found result for driver: \(result.Driver.fullName), Position: \(result.position)")
            return result
        } else {
            print("No race result found for driverId: \(driverId)")
            print("Available drivers: \(race.Results.map { $0.Driver.driverId })")
            return nil
        }
    }
}
