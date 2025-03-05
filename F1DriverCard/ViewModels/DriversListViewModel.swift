import Foundation

class DriversListViewModel: ObservableObject {
    @Published var drivers: [Driver] = []
    
    func fetchDrivers() async {
        let urlString = "https://api.jolpi.ca/ergast/f1/current/drivers.json"
        do {
            let response: DriverResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            DispatchQueue.main.async {
                self.drivers = response.MRData.DriverTable.Drivers
            }
        } catch {
            print("Error fetching drivers list: \(error)")
        }
    }
}
