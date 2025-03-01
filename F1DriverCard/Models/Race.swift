import Foundation

struct RaceResultResponse: Codable {
    let MRData: RaceResultMRData
}

struct RaceResultMRData: Codable {
    let RaceTable: RaceResultRaceTable
}

struct RaceResultRaceTable: Codable {
    let season: String
    let round: String
    let Races: [Race]
}

struct Race: Codable, Identifiable {
    var id: String { round }
    let season: String
    let round: String
    let raceName: String
    let date: String
    let Results: [Result]
}

struct Result: Codable, Identifiable {
    var id: String { Driver.driverId }
    let number: String
    let position: String
    let points: String
    let Driver: RaceResultDriver
    let Constructor: RaceResultConstructor
}

struct RaceResultDriver: Codable {
    let driverId: String
    let givenName: String
    let familyName: String
    var fullName: String { "\(givenName) \(familyName)" }
}

struct RaceResultConstructor: Codable {
    let constructorId: String
    let name: String
}
