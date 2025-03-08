// MARK: - Constructor Models
struct DriverConstructorsResponse: Decodable {
    let mrData: DriverConstructorsMRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct DriverConstructorsMRData: Decodable {
    let constructorTable: DriverConstructorTable
    
    private enum CodingKeys: String, CodingKey {
        case constructorTable = "ConstructorTable"
    }
}

struct DriverConstructorTable: Decodable {
    let driverId: String
    let constructors: [RaceResultConstructor]
    
    private enum CodingKeys: String, CodingKey {
        case driverId
        case constructors = "Constructors"
    }
}
