import Foundation

struct DriverStandingsResponse: Decodable {
    let MRData: StandingsMRData
}

struct StandingsMRData: Decodable {
    let StandingsTable: StandingsTable
}

struct StandingsTable: Decodable {
    let StandingsLists: [StandingsList]
}

struct StandingsList: Decodable {
    let DriverStandings: [DriverStanding]
}

struct DriverStanding: Decodable {
    let position: String
    let points: String
    let Driver: Driver
}
