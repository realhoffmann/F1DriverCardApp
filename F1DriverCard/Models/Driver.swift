import Foundation

struct DriverResponse: Codable {
    let MRData: MRData
}

struct MRData: Codable {
    let DriverTable: DriverTable
}

struct DriverTable: Codable {
    let Drivers: [Driver]
}

struct Driver: Codable, Identifiable {
    var id: String { driverId }
    let driverId: String
    let permanentNumber: String?
    let code: String?
    let url: String
    let givenName: String
    let familyName: String
    let dateOfBirth: String
    let nationality: String
    
    var fullName: String { "\(givenName) \(familyName)" }
}

extension Driver {
    /// Returns the URL for the background image of the driver.
    /// If the driverId is "max_verstappen", it uses "verstappen" as the image name.
    var backgroundImageURL: URL? {
        var imageId = driverId
        if imageId.lowercased() == "max_verstappen" {
            imageId = "verstappen"
        }
        let urlString = "https://media.formula1.com/image/upload/f_auto,c_limit,q_75,w_1320/content/dam/fom-website/drivers/2024Drivers/\(imageId)"
        return URL(string: urlString)
    }
}
