import Foundation

class QualifyingViewModel: ObservableObject {
    @Published var qualifyingRace: QualifyingRace?
    @Published var qualifyingPosition: String = ""
    @Published var lapTime: String = ""
    
    func fetchQualifyingResult(for driverId: String) async {
        // TODO: change 2024 to current once season starts
        let urlString = "https://api.jolpi.ca/ergast/f1/2024/last/qualifying.json"
        do {
            let response: QualifyingResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let race = response.MRData.RaceTable.Races.first {
                if let result = race.QualifyingResults.first(where: { $0.Driver.driverId.lowercased() == driverId.lowercased() }) {
                    DispatchQueue.main.async {
                        self.qualifyingPosition = result.position
                        self.lapTime = result.Q3 ?? result.Q2 ?? result.Q1 ?? "N/A"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.qualifyingPosition = "N/A"
                    }
                }
            }
        } catch {
            print("Error fetching qualifying data: \(error)")
            DispatchQueue.main.async {
                self.qualifyingPosition = "N/A"
            }
        }
    }
}
