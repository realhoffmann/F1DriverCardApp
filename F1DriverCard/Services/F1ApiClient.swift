import Foundation

enum ApiError: Error {
    case invalidURL
    case responseError
    case decodingError
}

class F1ApiClient {
    static let shared = F1ApiClient()
    
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
            throw ApiError.decodingError
        }
    }
}
