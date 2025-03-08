import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var driver: Driver?
    @Published var championships: Int = 0
    
    var driverImage: String {
        driver?.familyName.lowercased() ?? "f1Logo"
    }
    
    var helmetImage: String {
        (driver?.familyName.lowercased() ?? "f1Logo") + "Helmet"
    }
    
    var flagImage: String {
        driver?.nationality.lowercased() ?? "british"
    }
    
    func fetchDriverData() async {
        // Retrieve favorite driverId; default to "verstappen" which becomes "max_verstappen"
        var storedId = UserDefaults.standard.string(forKey: "favoriteDriverId") ?? "verstappen"
        if storedId.lowercased() == "verstappen" {
            storedId = "max_verstappen"
        }
        
        let urlString = APIEndpoints.driverData(driverId: storedId)
        do {
            let response: DriverResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let fetchedDriver = response.mrData.driverTable.drivers.first {
                self.driver = fetchedDriver
            } else {
                print("Driver not found for driverId \(storedId)")
            }
        } catch {
            print("Error fetching driver data: \(error)")
        }
    }
}
