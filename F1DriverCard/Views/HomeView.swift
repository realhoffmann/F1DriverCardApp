import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @StateObject var driverStandingsViewModel = DriverStandingsViewModel()
    @AppStorage("favoriteDriverId")
    var favoriteDriverId: String = "max_verstappen"
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                ForEach(0..<viewModel.championships, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
                Spacer()
            }
            HStack {
                // Flag
                Image(.netherlandsFlag)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                Spacer()
                // Championship Stars
                HStack {
                    Text(viewModel.driver?.permanentNumber ?? "")
                        .font(.f1Bold(30))
                        .foregroundColor(.gray)
                }
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
                Image(viewModel.helemtImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 130)
                    .padding(.leading, -30)
                Spacer()
            }
            Spacer()
            
            // Last Race Results
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if let driverId = viewModel.driver?.driverId,
                       let driverResult = raceResultViewModel.resultForDriver(driverId) {
                        Text("\(raceResultViewModel.race?.raceName ?? "Unknown")")
                            .font(.f1Bold(20))
                            .foregroundColor(.white)
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray)
                        HStack {
                            Text("Qualified: \(viewModel.qualifyingPosition)")
                                .font(.f1Regular(18))
                                .foregroundColor(.white)
                            Spacer()
                            Text("1:09.226")
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
                Image(.australia)
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
//Image(.redBullRacingCar)
//    .resizable()
//    .scaledToFit()
//    .frame(height: 100)
//
//Image(systemName: "chevron.down")
//    .resizable()
//    .scaledToFit()
//    .frame(height: 8)
//    .foregroundStyle(.gray)
//Image(.redBullLogo)
//    .resizable()
//    .scaledToFit()
//    .frame(height: 100)
//.padding(.horizontal, -30)
