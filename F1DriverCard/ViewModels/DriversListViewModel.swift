import Foundation

@MainActor
class DriversListViewModel: ObservableObject {
    @Published var drivers: [Driver] = []
    
    func fetchDrivers() async {
        do {
            let response: DriverResponse = try await F1ApiClient.shared.fetchData(from: APIEndpoints.drivers)
            self.drivers = response.mrData.driverTable.drivers
        } catch {
            print("Error fetching drivers list: \(error)")
        }
    }
}
