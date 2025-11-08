import Foundation

@MainActor
class RaceResultViewModel: ObservableObject {
    @Published var race: Race?
    @Published var raceSchedule: RaceSchedule?
    @Published private(set) var currentRound: Int = 1
    
    func updateFromSchedule(_ schedule: RaceSchedule) {
        self.raceSchedule = schedule
        self.currentRound = Int(schedule.round) ?? 1
        Task { await fetchRaceData() }
    }
    
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
    
    func getLastRaceForDriverMapping() async -> Race? {
        do {
            let scheduleResponse: RaceScheduleResponse = try await F1ApiClient.shared.fetchData(
                from: APIEndpoints.races
            )
            let races = scheduleResponse.mrData.raceTable.races
            
            let currentRoundStr = findCurrentRace(in: races)
            let previousRoundStr: String?
            if let currentRoundStr,
               let cur = Int(currentRoundStr),
               cur > 1 {
                previousRoundStr = String(cur - 1)
            } else {
                previousRoundStr = races.last?.round
            }
            guard let previousRoundStr else { return nil }
            
            let resultResponse: RaceResultResponse = try await F1ApiClient.shared.fetchData(
                from: APIEndpoints.raceResults(round: previousRoundStr)
            )
            guard let fetchedRace = resultResponse.mrData.raceTable.races.first,
                  !fetchedRace.results.isEmpty else { return nil }
            return fetchedRace
        } catch {
            print("Error fetching last completed race for mapping: \(error)")
            return nil
        }
    }
    
    private func findCurrentRace(in races: [RaceSchedule]) -> String? {
        let df = RaceScheduleViewModel.dateFormatter
        let today = Calendar.current.startOfDay(for: Date())
        for race in races {
            guard let raceDate = df.date(from: race.date) else { continue }
            if Calendar.current.startOfDay(for: raceDate) >= today {
                return race.round
            }
        }
        return nil
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
        guard let race else {
            print("Race data is not available yet")
            return nil
        }
        return race.results.first(where: { $0.driver.driverId.lowercased() == driverId.lowercased() })
    }
}
