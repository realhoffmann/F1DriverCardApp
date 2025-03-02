import Foundation

struct DriverStandingsResponse: Codable {
    let MRData: StandingsMRData
}

struct StandingsMRData: Codable {
    let StandingsTable: StandingsTable
}

struct StandingsTable: Codable {
    let StandingsLists: [StandingsList]
}

struct StandingsList: Codable {
    let DriverStandings: [DriverStanding]
}

struct DriverStanding: Codable {
    let position: String
    let points: String
    let Driver: Driver
}
