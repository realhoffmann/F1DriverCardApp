// MARK: - Race Schedule Models
struct RaceScheduleResponse: Decodable {
    let mrData: RaceScheduleMRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct RaceScheduleMRData: Decodable {
    let raceTable: RaceScheduleTable
    
    private enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

struct RaceScheduleTable: Decodable {
    let season: String
    let races: [RaceSchedule]
    
    private enum CodingKeys: String, CodingKey {
        case season
        case races = "Races"
    }
}

struct RaceSchedule: Decodable, Identifiable {
    var id: String { round }
    let season: String
    let round: String
    let raceName: String
    let date: String
    let time: String
    let Circuit: RaceCircuitSchedule
    let FirstPractice: PracticeSession?
    let SecondPractice: PracticeSession?
    let ThirdPractice: PracticeSession?
    let Qualifying: PracticeSession?
    let SprintQualifying: PracticeSession?
    let Sprint: PracticeSession?
}

struct RaceCircuitSchedule: Decodable {
    let circuitId: String
    let circuitName: String
}

struct PracticeSession: Decodable {
    let date: String
    let time: String
}
