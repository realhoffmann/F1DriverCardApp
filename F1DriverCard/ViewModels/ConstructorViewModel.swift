import Foundation

@MainActor
final class ConstructorViewModel: ObservableObject {
    @Published var constructor: RaceResultConstructor?
    @Published var constructors: [RaceResultConstructor] = []
    
    func fetchConstructor(for driverId: String) async {
        let urlString = APIEndpoints.driverConstructors(driverId: driverId)
        do {
            let response: DriverConstructorsResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            self.constructor = response.mrData.constructorTable.constructors.first
        } catch {
            print("Error fetching driver constructor: \(error)")
        }
    }
    
    func fetchConstructors() async {
        do {
            let response: ConstructorsResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.constructors)
            self.constructors = response.mrData.constructorTable.constructors
        } catch {
            print("Error fetching constructors: \(error)")
        }
    }
}
