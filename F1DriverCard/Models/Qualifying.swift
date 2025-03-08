// MARK: - Qualifying Models
struct QualifyingResponse: Decodable {
    let mrData: QualifyingMRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct QualifyingMRData: Decodable {
    let raceTable: QualifyingRaceTable
    
    private enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

struct QualifyingRaceTable: Decodable {
    let races: [QualifyingRace]
    
    private enum CodingKeys: String, CodingKey {
        case races = "Races"
    }
}

struct QualifyingRace: Decodable {
    let season: String
    let round: String
    let qualifyingResults: [QualifyingResult]
    
    private enum CodingKeys: String, CodingKey {
        case season, round
        case qualifyingResults = "QualifyingResults"
    }
}

struct QualifyingResult: Decodable, Identifiable {
    var id: String { driver.driverId }
    let position: String
    let driver: QualifyingDriver
    let q1: String?
    let q2: String?
    let q3: String?
    
    private enum CodingKeys: String, CodingKey {
        case position
        case driver = "Driver"
        case q1 = "Q1"
        case q2 = "Q2"
        case q3 = "Q3"
    }
}

struct QualifyingDriver: Decodable, DriverNameable {
    let driverId: String
    let givenName: String
    let familyName: String
}
