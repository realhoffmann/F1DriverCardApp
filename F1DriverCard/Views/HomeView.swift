import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var raceResultViewModel: RaceResultViewModel
    @ObservedObject var raceScheduleViewModel: RaceScheduleViewModel
    @ObservedObject var driverStandingsViewModel: DriverStandingsViewModel
    @ObservedObject var qualifyingViewModel: QualifyingViewModel
    @AppStorage("favoriteDriverId") var favoriteDriverId: String = "max_verstappen"
    @State private var dragOffset: CGFloat = 0
    @State private var showDriverSettings: Bool = false
    
    private func updateRaceData() async {
        let round = String(raceScheduleViewModel.currentRound)
        async let qualifyingCall: () = qualifyingViewModel.fetchQualifyingResult(
            for: favoriteDriverId,
            round: round
        )
        async let standingsCall: () = driverStandingsViewModel.fetchDriverStandings(
            for: favoriteDriverId,
            round: round
        )
        _ = await (qualifyingCall, standingsCall)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            DriverInfoView(
                viewModel: viewModel,
                raceResultViewModel: raceResultViewModel,
                showDriverSettings: $showDriverSettings
            )
            
            RaceDetailsView(
                raceResultViewModel: raceResultViewModel,
                raceScheduleViewModel: raceScheduleViewModel,
                qualifyingViewModel: qualifyingViewModel,
                driverStandingsViewModel: driverStandingsViewModel,
                viewModel: viewModel,
                favoriteDriverId: $favoriteDriverId
            )

            TrackImageView(
                raceResultViewModel: raceResultViewModel,
                raceScheduleViewModel: raceScheduleViewModel,
                dragOffset: $dragOffset,
                updateRaceData: updateRaceData
            )
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
            raceScheduleViewModel.attach(resultVM: raceResultViewModel)
            await viewModel.fetchDriverData()
            await raceResultViewModel.fetchRaceData()
            await raceScheduleViewModel.fetchRaceSchedule()
            await driverStandingsViewModel.fetchDriverStandings(for: favoriteDriverId)
            await qualifyingViewModel.fetchQualifyingResult(for: favoriteDriverId)
        }
        .onChange(of: favoriteDriverId) { _, newValue in
            Task {
                await viewModel.fetchDriverData()
                await raceResultViewModel.fetchRaceData()
                await raceScheduleViewModel.fetchRaceSchedule()
                await driverStandingsViewModel.fetchDriverStandings(for: newValue)
                await qualifyingViewModel.fetchQualifyingResult(for: newValue)
            }
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(),
        raceResultViewModel: RaceResultViewModel(),
        raceScheduleViewModel: RaceScheduleViewModel(),
        driverStandingsViewModel: DriverStandingsViewModel(),
        qualifyingViewModel: QualifyingViewModel()
    )
}
