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
    
    static func driverStandings(round: String = "last") -> String {
        return "\(baseURL)/\(current)/\(round)/driverStandings.json"
    }
    
    static func qualifying(round: String = "last") -> String {
        return "\(baseURL)/\(current)/\(round)/qualifying.json"
    }
    
    static func raceResults(round: String = "last") -> String {
        return "\(baseURL)/\(current)/\(round)/results.json"
    }
    
    static func driverConstructors(driverId: String) -> String {
        return "\(baseURL)/\(current)/drivers/\(driverId)/constructors.json"
    }
    
    static var constructors: String {
        return "\(baseURL)/\(current)/constructors.json"
    }
    
    static var races: String {
        return "\(baseURL)/\(current)/races.json"
    }
}
