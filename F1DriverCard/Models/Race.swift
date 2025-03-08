import Foundation

struct RaceResultResponse: Decodable {
    let MRData: RaceResultMRData
}

struct RaceResultMRData: Decodable {
    let RaceTable: RaceResultRaceTable
}

struct RaceResultRaceTable: Decodable {
    let season: String
    let round: String
    let Races: [Race]
}

struct Race: Decodable, Identifiable {
    var id: String { round }
    let season: String
    let round: String
    let raceName: String
    let date: String
    let Results: [Result]
    let Circuit: Circuit
}

struct Result: Decodable, Identifiable {
    var id: String { Driver.driverId }
    let number: String
    let position: String
    let points: String
    let Driver: RaceResultDriver
    let Constructor: RaceResultConstructor
}

struct Circuit: Decodable {
    let circuitId: String
    let circuitName: String
}

struct RaceResultDriver: Decodable {
    let driverId: String
    let givenName: String
    let familyName: String
    var fullName: String { "\(givenName) \(familyName)" }
}

struct RaceResultConstructor: Decodable {
    let constructorId: String
    let name: String
}
