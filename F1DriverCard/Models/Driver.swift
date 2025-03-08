import Foundation

struct DriverResponse: Decodable {
    let MRData: MRData
}

struct MRData: Decodable {
    let DriverTable: DriverTable
}

struct DriverTable: Decodable {
    let Drivers: [Driver]
}

struct Driver: Decodable, Identifiable {
    var id: String { driverId }
    let driverId: String
    let permanentNumber: String?
    let code: String?
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    
    var fullName: String { "\(givenName) \(familyName)" }
}
