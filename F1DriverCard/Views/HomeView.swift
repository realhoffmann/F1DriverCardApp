import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @StateObject var driverStandingsViewModel = DriverStandingsViewModel()
    @StateObject var qualifyingViewModel = QualifyingViewModel()
    @AppStorage("favoriteDriverId") var favoriteDriverId: String = "max_verstappen"
    
    var body: some View {
        VStack(spacing: 16) {
            // Top Bar: Flag and permanent number
            HStack {
                Image(viewModel.flagImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Spacer()
                Text(viewModel.driver?.permanentNumber ?? "")
                    .font(.f1Bold(30))
                    .foregroundColor(.gray)
            }
            
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
                Image(systemName: "chevron.down")
                    .foregroundStyle(.gray)
                Spacer()
            }
            
            // Helmet Image
            HStack {
                Image(viewModel.helmetImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .padding(.leading, -30)
                Spacer()
            }
            Spacer()
            
            // Race Results
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if let driverId = viewModel.driver?.driverId,
                       let driverResult = raceResultViewModel.resultForDriver(driverId) {
                        Text(raceResultViewModel.race?.raceName ?? "Unknown")
                            .font(.f1Bold(20))
                            .foregroundColor(.white)
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray)
                        HStack {
                            Text("Qualified: \(qualifyingViewModel.qualifyingPosition)")
                                .font(.f1Regular(18))
                                .foregroundColor(.white)
                            Spacer()
                            Text(qualifyingViewModel.lapTime)
                                .font(.f1Regular(18))
                                .foregroundColor(.white)
                        }
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray)
                        Text("Finished: \(driverResult.position)")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray)
                        Text("Points: \(driverResult.points)")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray)
                        Text("Championship Position: \(driverStandingsViewModel.championshipPosition)")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    } else {
                        Text("Loading race result...")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            
            // Track Image
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.gray)
                Spacer()
                Image(raceResultViewModel.trackImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
        .background(
            Image(viewModel.driverImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.7))
        )
        .task {
            await viewModel.fetchDriverData()
            await raceResultViewModel.fetchRaceResult()
            await driverStandingsViewModel.fetchDriverStandings(for: favoriteDriverId)
            await qualifyingViewModel.fetchQualifyingResult(for: favoriteDriverId)
        }
        .onChange(of: favoriteDriverId) { _ in
            Task {
                await viewModel.fetchDriverData()
                await raceResultViewModel.fetchRaceResult()
                await driverStandingsViewModel.fetchDriverStandings(for: favoriteDriverId)
                await qualifyingViewModel.fetchQualifyingResult(for: favoriteDriverId)
            }
        }
    }
}

#Preview {
    HomeView()
}
