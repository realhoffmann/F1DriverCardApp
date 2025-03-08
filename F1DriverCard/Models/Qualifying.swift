import Foundation

struct QualifyingResponse: Decodable {
    let MRData: QualifyingMRData
}

struct QualifyingMRData: Decodable {
    let RaceTable: QualifyingRaceTable
}

struct QualifyingRaceTable: Decodable {
    let Races: [QualifyingRace]
}

struct QualifyingRace: Decodable {
    let season: String
    let round: String
    let QualifyingResults: [QualifyingResult]
}

struct QualifyingResult: Decodable, Identifiable {
    var id: String { Driver.driverId }
    let position: String
    let Driver: QualifyingDriver
    let Q1: String?
    let Q2: String?
    let Q3: String?
}

struct QualifyingDriver: Decodable {
    let driverId: String
    let givenName: String
    let familyName: String
    
    var fullName: String { "\(givenName) \(familyName)" }
}
