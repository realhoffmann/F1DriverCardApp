// MARK: - Race Result Models

struct RaceResultResponse: Decodable {
    let mrData: RaceResultMRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct RaceResultMRData: Decodable {
    let raceTable: RaceResultRaceTable
    
    private enum CodingKeys: String, CodingKey {
        case raceTable = "RaceTable"
    }
}

struct RaceResultRaceTable: Decodable {
    let season: String
    let round: String
    let races: [Race]
    
    private enum CodingKeys: String, CodingKey {
        case season, round
        case races = "Races"
    }
}

struct Race: Decodable, Identifiable {
    var id: String { round }
    let season: String
    let round: String
    let raceName: String
    let date: String
    let results: [Result]
    let circuit: Circuit
    
    private enum CodingKeys: String, CodingKey {
        case season, round, raceName, date
        case results = "Results"
        case circuit = "Circuit"
    }
}

struct Result: Decodable, Identifiable {
    var id: String { driver.driverId }
    let number: String
    let position: String
    let points: String
    let driver: RaceResultDriver
    let constructor: RaceResultConstructor
    
    private enum CodingKeys: String, CodingKey {
        case number, position, points
        case driver = "Driver"
        case constructor = "Constructor"
    }
}

struct Circuit: Decodable {
    let circuitId: String
    let circuitName: String
    
    private enum CodingKeys: String, CodingKey {
        case circuitId, circuitName
    }
}

struct RaceResultDriver: Decodable, DriverNameable {
    let driverId: String
    let givenName: String
    let familyName: String
}

struct RaceResultConstructor: Decodable {
    let constructorId: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case constructorId, name
    }
}
