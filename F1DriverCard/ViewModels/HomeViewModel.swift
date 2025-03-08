import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var driver: Driver?
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @Published var championships: Int = 0
    
    var driverImage: String {
        if let lastName = driver?.familyName {
            return lastName.lowercased()
        } else {
            return "f1Logo"
        }
    }
    
    var helemtImage: String {
        if let lastName = driver?.familyName {
            return lastName.lowercased() + "Helmet"
        } else {
            return "f1Logo"
        }
    }
    
    var flagImage: String {
        if let nationality = driver?.nationality {
            return nationality.lowercased()
        } else {
            return "british"
        }
    }
    
    func fetchDriverData() async {
        // Retrieve the favorite driverId; default to "max_verstappen"
        var storedId = UserDefaults.standard.string(forKey: "favoriteDriverId") ?? "verstappen"
        // If the stored id is "verstappen", use "max_verstappen"
        if storedId.lowercased() == "verstappen" {
            storedId = "max_verstappen"
        }
        
        // Build the URL using HTTPS and the current season path.
        let urlString = "https://api.jolpi.ca/ergast/f1/current/drivers/\(storedId).json"
        
        do {
            let response: DriverResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let fetchedDriver = response.MRData.DriverTable.Drivers.first {
                DispatchQueue.main.async {
                    self.driver = fetchedDriver
                }
                // Fetch the latest qualifying result for this driver from round last of the current season
                await QualifyingViewModel().fetchQualifyingResult(for: fetchedDriver.driverId)
            } else {
                print("Driver not found for driverId \(storedId)")
            }
        } catch {
            print("Error fetching driver data: \(error)")
        }
    }
}
