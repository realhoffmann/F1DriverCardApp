import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var driver: Driver?
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @Published var qualifyingPosition: String = ""
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
        // If the stored id (case-insensitive) is "verstappen", use "max_verstappen"
        if storedId.lowercased() == "verstappen" {
            storedId = "max_verstappen"
        }
        
        // Build the URL using HTTPS and the current season path.
        let urlString = "https://ergast.com/api/f1/current/drivers/\(storedId).json"
        
        do {
            let response: DriverResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let fetchedDriver = response.MRData.DriverTable.Drivers.first {
                DispatchQueue.main.async {
                    self.driver = fetchedDriver
                }
                // Fetch the latest qualifying result for this driver from round last of the current season
                await fetchQualifyingResult(for: fetchedDriver.driverId)
            } else {
                print("Driver not found for driverId \(storedId)")
            }
        } catch {
            print("Error fetching driver data: \(error)")
        }
    }
    
    // Fetch the qualifying result for the given driver from the current round last qualifying endpoint.
    private func fetchQualifyingResult(for driverId: String) async {
        let urlString = "https://ergast.com/api/f1/current/last/qualifying.json"
        do {
            let response: QualifyingResponse = try await F1ApiClient.shared.fetchData(from: urlString)
            if let race = response.MRData.RaceTable.Races.first {
                if let result = race.QualifyingResults.first(where: { $0.Driver.driverId.lowercased() == driverId.lowercased() }) {
                    DispatchQueue.main.async {
                        self.qualifyingPosition = result.position
                    }
                } else {
                    DispatchQueue.main.async {
                        self.qualifyingPosition = "N/A"
                    }
                }
            }
        } catch {
            print("Error fetching qualifying data: \(error)")
            DispatchQueue.main.async {
                self.qualifyingPosition = "N/A"
            }
        }
    }
}
