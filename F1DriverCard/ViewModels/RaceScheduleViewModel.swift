import Foundation

@MainActor

class RaceScheduleViewModel: ObservableObject {
    @Published var raceSchedule: RaceSchedule? {
        didSet { notifyDependents() }
    }
    @Published private(set) var currentRound: Int = 1
    @Published private(set) var allRaces: [RaceSchedule] = []
    weak var raceResultViewModel: RaceResultViewModel?
    
    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(abbreviation: "UTC")
        return df
    }()

    var trackImage: String {
        guard let raceSchedule else { return "yas_marina_track" }
        return raceSchedule.Circuit.circuitId.lowercased() + "_track"
        
    }
    
    func attach(resultVM: RaceResultViewModel) {
        self.raceResultViewModel = resultVM
        if let schedule = raceSchedule {
            resultVM.updateFromSchedule(schedule)
        }
    }

    func fetchRaceSchedule() async {
        do {
            let scheduleResponse: RaceScheduleResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.races)
            let races = scheduleResponse.mrData.raceTable.races
            self.allRaces = races

            if let nextRace = findCurrentRace(in: races) {
                self.currentRound = Int(nextRace.round) ?? 1
                self.raceSchedule = nextRace
            } else if let firstRace = races.first {
                self.currentRound = Int(firstRace.round) ?? 1
                self.raceSchedule = firstRace
            }
        } catch {
            print("Error fetching all races: \(error)")
        }
    }

    func fetchNextRaceSchedule() {
        guard let currentIndex = allRaces.firstIndex(where: { $0.round == String(currentRound) }) else { return }
        let nextIndex = currentIndex + 1
        if allRaces.indices.contains(nextIndex) {
            showRace(at: nextIndex)
        }
    }

    func fetchPreviousRaceSchedule() {
        guard let currentIndex = allRaces.firstIndex(where: { $0.round == String(currentRound) }) else { return }
        let prevIndex = currentIndex - 1
        if allRaces.indices.contains(prevIndex) {
            showRace(at: prevIndex)
        }
    }

    private func showRace(at index: Int) {
        guard allRaces.indices.contains(index) else { return }
        let selectedRace = allRaces[index]
        self.raceSchedule = selectedRace
        self.currentRound = Int(selectedRace.round) ?? 1
    }

    private func findCurrentRace(in races: [RaceSchedule]) -> RaceSchedule? {
        let today = Date()
        let dateFormatter = RaceScheduleViewModel.dateFormatter

        return races.first(where: { race in
            guard let raceDate = dateFormatter.date(from: race.date) else { return false }
            return raceDate >= today
        })
    }
    
    private func notifyDependents() {
        guard let raceSchedule else { return }
        raceResultViewModel?.updateFromSchedule(raceSchedule)
    }
}
