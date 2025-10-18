import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @StateObject var raceResultViewModel = RaceResultViewModel()
    @StateObject var raceScheduleViewModel = RaceScheduleViewModel()
    @StateObject var driverStandingsViewModel = DriverStandingsViewModel()
    @StateObject var qualifyingViewModel = QualifyingViewModel()
    @AppStorage("favoriteDriverId") var favoriteDriverId: String = "max_verstappen"
    @AppStorage("selectedTimeZoneID") private var selectedTimeZoneID: String = TimeZone.current.identifier
    @State private var dragOffset: CGFloat = 0
    @State private var showDriverSettings: Bool = false
    
    private var selectedTimeZone: TimeZone {
        TimeZone(identifier: selectedTimeZoneID) ?? .current
    }
    private var selectedTimeZoneBinding: Binding<TimeZone> {
        Binding<TimeZone>(
            get: { selectedTimeZone },
            set: { newValue in
                selectedTimeZoneID = newValue.identifier
            }
        )
    }
    
    private func updateRaceData() async {
        let round = raceResultViewModel.race?.round ?? "last"
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
            DriverInfoView(viewModel: viewModel, showDriverSettings: $showDriverSettings)
            
            RaceDetailsView(
                raceResultViewModel: raceResultViewModel,
                raceScheduleViewModel: raceScheduleViewModel,
                qualifyingViewModel: qualifyingViewModel,
                driverStandingsViewModel: driverStandingsViewModel,
                viewModel: viewModel,
                favoriteDriverId: $favoriteDriverId,
                selectedTimeZone: selectedTimeZoneBinding
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
    HomeView()
}
