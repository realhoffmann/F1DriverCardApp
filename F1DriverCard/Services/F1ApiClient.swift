import Foundation

enum ApiError: Error {
    case invalidURL
    case responseError
    case decodingError
}

final class F1ApiClient {
    static let shared = F1ApiClient()
    private init() {}
    
    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ApiError.responseError
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            throw ApiError.decodingError
        }
    }
}

// MARK: - API Endpoints

enum APIEndpoints {
    static let baseURL = "https://api.jolpi.ca/ergast/f1"
    static let current = "current"
    
    static let drivers = "\(baseURL)/\(current)/drivers.json"
    
    static func driverData(driverId: String) -> String {
        return "\(baseURL)/\(current)/drivers/\(driverId).json"
    }
    
    static func driverStandings(season: String = "2024", round: String = "last") -> String {
        return "\(baseURL)/\(season)/\(round)/driverStandings.json"
    }
    
    static func qualifying(season: String = "2024", round: String = "last") -> String {
        return "\(baseURL)/\(season)/\(round)/qualifying.json"
    }
    
    static func raceResults(season: String = "2024", round: String = "last") -> String {
        return "\(baseURL)/\(season)/\(round)/results.json"
    }
}
