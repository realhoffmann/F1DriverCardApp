// MARK: - Protocol for common driver name properties
protocol DriverNameable: Decodable {
    var driverId: String { get }
    var givenName: String { get }
    var familyName: String { get }
}

extension DriverNameable {
    var fullName: String { "\(givenName) \(familyName)" }
}

// MARK: - Driver Models
struct DriverResponse: Decodable {
    let mrData: MRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct MRData: Decodable {
    let driverTable: DriverTable
    
    private enum CodingKeys: String, CodingKey {
        case driverTable = "DriverTable"
    }
}

struct DriverTable: Decodable {
    let drivers: [Driver]
    
    private enum CodingKeys: String, CodingKey {
        case drivers = "Drivers"
    }
}

struct Driver: Decodable, Identifiable, DriverNameable {
    var id: String { driverId }
    let driverId: String
    let permanentNumber: String?
    let code: String?
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
}
