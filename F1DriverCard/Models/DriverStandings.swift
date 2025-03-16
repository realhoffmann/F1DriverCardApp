// MARK: - Standings Models
struct DriverStandingsResponse: Decodable {
    let mrData: StandingsMRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct StandingsMRData: Decodable {
    let standingsTable: StandingsTable
    
    private enum CodingKeys: String, CodingKey {
        case standingsTable = "StandingsTable"
    }
}

struct StandingsTable: Decodable {
    let standingsLists: [StandingsList]
    
    private enum CodingKeys: String, CodingKey {
        case standingsLists = "StandingsLists"
    }
}

struct StandingsList: Decodable {
    let driverStandings: [DriverStanding]
    
    private enum CodingKeys: String, CodingKey {
        case driverStandings = "DriverStandings"
    }
}

struct DriverStanding: Decodable {
    let position: String?
    let points: String
    let driver: Driver
    
    private enum CodingKeys: String, CodingKey {
        case position, points
        case driver = "Driver"
    }
}
