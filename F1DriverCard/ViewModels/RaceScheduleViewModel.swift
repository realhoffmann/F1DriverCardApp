import Foundation

@MainActor
class RaceScheduleViewModel: ObservableObject {
    @Published var raceSchedule: RaceSchedule?
    @Published private(set) var currentRound: Int = 1
    
    var trackImage: String {
        if let schedule = raceSchedule {
            return schedule.Circuit.circuitId.lowercased() + "_track"
        }
        return "yas_marina_track"
    }
    
    func fetchRaceSchedule() async {
        let roundString = String(currentRound)
        do {
            let scheduleResponse: RaceScheduleResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.races)
            if let scheduleRace = scheduleResponse.mrData.raceTable.races.first(where: { $0.round == roundString }) {
                self.raceSchedule = scheduleRace
            } else {
                self.raceSchedule = nil
            }
        } catch {
            print("Error fetching race schedule: \(error)")
        }
    }
    
    func fetchNextRaceSchedule() async {
        currentRound += 1
        await fetchRaceSchedule()
    }
    
    func fetchPreviousRaceSchedule() async {
        if currentRound > 1 {
            currentRound -= 1
            await fetchRaceSchedule()
        } else {
            print("Already at first round")
        }
    }
}
