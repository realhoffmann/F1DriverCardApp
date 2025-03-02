import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @StateObject var driverStandingsViewModel = DriverStandingsViewModel()
    @AppStorage("favoriteDriverId")
    var favoriteDriverId: String = "max_verstappen"
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Championship Stars
            HStack {
                ForEach(0..<viewModel.championships, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 16))
                }
                Spacer()
            }
            .padding(.bottom, 8)
            
            // Driver Name
            HStack {
                Text(viewModel.driver?.givenName ?? "Loading...")
                    .font(.f1Wide(20))
                    .foregroundColor(.white)
                Spacer()
            }
            HStack {
                Text(viewModel.driver?.familyName.uppercased() ?? "Loading...")
                    .font(.f1Wide(20))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 16)
            
            // Last Race Results
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    if let driverId = viewModel.driver?.driverId,
                       let driverResult = raceResultViewModel.resultForDriver(driverId) {
                        Text("Last Race: \(raceResultViewModel.race?.raceName ?? "Unknown")")
                            .font(.f1Bold(18))
                            .foregroundColor(.white)
                        Text("Qualified: \(viewModel.qualifyingPosition)")
                            .font(.f1Regular(16))
                            .foregroundColor(.white)
                        Text("Finished: \(driverResult.position)")
                            .font(.f1Regular(16))
                            .foregroundColor(.white)
                        Text("Points: \(driverResult.points)")
                            .font(.f1Regular(16))
                            .foregroundColor(.white)
                        Text("Championship Position: \(driverStandingsViewModel.championshipPosition)")
                            .font(.f1Regular(16))
                            .foregroundColor(.white)
                    } else {
                        Text("Loading race result...")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            Spacer()
            
            // Helmet Image
            Image(viewModel.helemtImage)
                .resizable()
                .scaledToFit()
                .frame(width: 250)
        }
        .padding(.horizontal)
        .background(
            Image(viewModel.driverImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.6))
        )
        .task {
            await viewModel.fetchDriverData()
            await raceResultViewModel.fetchRaceResult()
            await driverStandingsViewModel.fetchDriverStandings(for: favoriteDriverId)
        }
        .onChange(of: favoriteDriverId) { _ in
            Task {
                await viewModel.fetchDriverData()
                await raceResultViewModel.fetchRaceResult()
                await driverStandingsViewModel.fetchDriverStandings(for: favoriteDriverId)
            }
        }
    }
}

#Preview {
    HomeView()
}
