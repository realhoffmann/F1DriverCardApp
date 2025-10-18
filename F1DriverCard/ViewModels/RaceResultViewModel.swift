import Foundation

@MainActor
class RaceResultViewModel: ObservableObject {
    @Published var race: Race?
    @Published var raceSchedule: RaceSchedule?
    @Published private(set) var currentRound: Int = 1
    
    func fetchRaceData() async {
        let roundString = String(currentRound)
        do {
            let resultResponse: RaceResultResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.raceResults(round: roundString))
            
            if let fetchedRace = resultResponse.mrData.raceTable.races.first,
               !fetchedRace.results.isEmpty {
                self.race = fetchedRace
                self.raceSchedule = nil
            } else {
                self.race = nil
                let scheduleResponse: RaceScheduleResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.races)
                if let scheduleRace = scheduleResponse.mrData.raceTable.races.first(where: { $0.round == roundString }) {
                    self.raceSchedule = scheduleRace
                } else {
                    self.raceSchedule = nil
                }
            }
        } catch {
            print("Error fetching race data: \(error)")
        }
    }
    
    func fetchNextRace() async {
        currentRound += 1
        await fetchRaceData()
    }
    
    func fetchPreviousRace() async {
        if currentRound > 1 {
            currentRound -= 1
            await fetchRaceData()
        } else {
            print("Already at first round")
        }
    }
    
    func resultForDriver(_ driverId: String) -> Result? {
        guard let race = race else {
            print("Race data is not available yet")
            return nil
        }
        return race.results.first(where: { $0.driver.driverId.lowercased() == driverId.lowercased() })
    }
}
