// MARK: - Constructors Models
struct ConstructorsResponse: Decodable {
    let mrData: ConstructorsMRData
    
    private enum CodingKeys: String, CodingKey {
        case mrData = "MRData"
    }
}

struct ConstructorsMRData: Decodable {
    let constructorTable: ConstructorTable
    
    private enum CodingKeys: String, CodingKey {
        case constructorTable = "ConstructorTable"
    }
}

struct ConstructorTable: Decodable {
    let season: String
    let constructors: [RaceResultConstructor]
    
    private enum CodingKeys: String, CodingKey {
        case season
        case constructors = "Constructors"
    }
}
