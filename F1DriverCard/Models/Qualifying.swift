import Foundation

struct QualifyingResponse: Codable {
    let MRData: QualifyingMRData
}

struct QualifyingMRData: Codable {
    let RaceTable: QualifyingRaceTable
}

struct QualifyingRaceTable: Codable {
    let Races: [QualifyingRace]
}

struct QualifyingRace: Codable {
    let season: String
    let round: String
    let QualifyingResults: [QualifyingResult]
}

struct QualifyingResult: Codable, Identifiable {
    var id: String { Driver.driverId }
    let position: String
    let Driver: QualifyingDriver
    let Q1: String?
    let Q2: String?
    let Q3: String?
}

struct QualifyingDriver: Codable {
    let driverId: String
    let givenName: String
    let familyName: String
    
    var fullName: String { "\(givenName) \(familyName)" }
}
