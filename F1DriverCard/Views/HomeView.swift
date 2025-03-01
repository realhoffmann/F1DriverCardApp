import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @AppStorage("favoriteDriverId")
    var favoriteDriverId: String = "max_verstappen"
    @State private var showSettings = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Championship Stars
            HStack() {
                ForEach(0..<viewModel.championships, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                }
                Spacer()
            }
            
            // Driver Name
            HStack() {
                Text(viewModel.driver?.fullName ?? "Loading...")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.bottom, 16)
            
            // Last Race Results
            HStack() {
                VStack(alignment: .leading, spacing: 4) {
                    if let driverId = viewModel.driver?.driverId,
                       let driverResult = raceResultViewModel.resultForDriver(driverId) {
                        Text("Last Race: \(raceResultViewModel.race?.raceName ?? "Unknown")")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text("Qualified: \(viewModel.qualifyingPosition)")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Text("Finished: \(driverResult.position)")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Text("Points: \(driverResult.points)")
                            .font(.system(size: 18))
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
        }
        .padding(.horizontal)
        .background(
            Group {
                if let driver = viewModel.driver,
                   let url = driver.backgroundImageURL {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                } else {
                    Color.black
                }
            }
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.6))
        )
        .task {
            await viewModel.fetchDriverData()
            await raceResultViewModel.fetchRaceResult()
        }
        .onChange(of: favoriteDriverId) { _ in
            Task {
                await viewModel.fetchDriverData()
                await raceResultViewModel.fetchRaceResult()
            }
        }
    }
}

#Preview {
    HomeView()
}
