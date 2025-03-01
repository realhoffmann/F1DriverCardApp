import SwiftUI

struct DriverSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("favoriteDriverId")
    var favoriteDriverId: String = "max_verstappen"
    @StateObject var viewModel = DriversListViewModel()
    
    var body: some View {
        VStack {
            List(viewModel.drivers) { driver in
                HStack {
                    Text(driver.fullName)
                    Spacer()
                    if driver.driverId == favoriteDriverId {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    favoriteDriverId = driver.driverId
                }
            }
        }
        .task {
            await viewModel.fetchDrivers()
        }
    }
}

#Preview {
    DriverSettingsView()
}
