import SwiftUI

struct RaceDetailsView: View {
    @ObservedObject var raceResultViewModel: RaceResultViewModel
    @ObservedObject var raceScheduleViewModel: RaceScheduleViewModel
    @ObservedObject var qualifyingViewModel: QualifyingViewModel
    @ObservedObject var driverStandingsViewModel: DriverStandingsViewModel
    @ObservedObject var viewModel: HomeViewModel
    @Binding var favoriteDriverId: String
    @Binding var selectedTimeZone: TimeZone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let driverId = viewModel.driver?.driverId,
               let driverResult = raceResultViewModel.resultForDriver(driverId) {
                Text(raceScheduleViewModel.raceSchedule?.raceName ?? "Unknown")
                    .font(.f1Bold(20))
                    .foregroundColor(.white)
                Divider().frame(height: 1).overlay(.gray)
                HStack {
                    Text("Qualified: \(qualifyingViewModel.qualifyingPosition)")
                        .font(.f1Regular(18))
                        .foregroundColor(.white)
                    Spacer()
                    Text(qualifyingViewModel.lapTime)
                        .font(.f1Regular(18))
                        .foregroundColor(.white)
                }
                Divider().frame(height: 1).overlay(.gray)
                Text("Finished: \(driverResult.position)")
                    .font(.f1Regular(18))
                    .foregroundColor(.white)
                Divider().frame(height: 1).overlay(.gray)
                Text("Points: \(driverResult.points)")
                    .font(.f1Regular(18))
                    .foregroundColor(.white)
                Divider().frame(height: 1).overlay(.gray)
                Text("Championship Position: \(driverStandingsViewModel.championshipPosition)")
                    .font(.f1Regular(18))
                    .foregroundColor(.white)
            } else if let schedule = raceScheduleViewModel.raceSchedule {
                Text(schedule.raceName)
                    .font(.f1Bold(20))
                    .foregroundColor(.white)
                Divider().frame(height: 1).overlay(.gray)
                
                if let firstPractice = schedule.FirstPractice,
                   let date = makeDate(dateString: firstPractice.date, timeString: firstPractice.time) {
                    row(title: "First Practice", date: date)
                }
                
                if let secondPractice = schedule.SecondPractice,
                   let date = makeDate(dateString: secondPractice.date, timeString: secondPractice.time) {
                    row(title: "Second Practice", date: date)
                } else if let sprintQualifying = schedule.SprintQualifying,
                          let date = makeDate(dateString: sprintQualifying.date, timeString: sprintQualifying.time) {
                    row(title: "Sprint Qualifying", date: date)
                }
                
                if let thirdPractice = schedule.ThirdPractice,
                   let date = makeDate(dateString: thirdPractice.date, timeString: thirdPractice.time) {
                    row(title: "Third Practice", date: date)
                } else if let sprint = schedule.Sprint,
                          let date = makeDate(dateString: sprint.date, timeString: sprint.time) {
                    row(title: "Sprint", date: date)
                }
                
                if let qualifying = schedule.Qualifying,
                   let date = makeDate(dateString: qualifying.date, timeString: qualifying.time) {
                    row(title: "Qualifying", date: date)
                }
                
                if let raceDate = makeDate(dateString: schedule.date, timeString: schedule.time) {
                    row(title: "Race", date: raceDate)
                }
            } else {
                Text("Loading race data...")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }
    
// MARK: - Helpers
    @ViewBuilder
    private func row(title: String, date: Date) -> some View {
        HStack {
            Text("\(title): ")
                .font(.f1Regular(18))
                .foregroundColor(.white)
            Spacer()
            Text(formatLocalDateTime(date: date))
                .font(.f1Regular(18))
                .foregroundColor(.white)
        }
        Divider().frame(height: 1).overlay(.gray)
    }
    
    private func makeDate(dateString: String, timeString: String) -> Date? {
        /// API provides e.g. date "2025-03-23" and time "07:00:00Z"
        let isoString = "\(dateString)T\(timeString)"
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        return iso.date(from: isoString)
    }
    
    private func formatLocalDateTime(date: Date) -> String {
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = selectedTimeZone
        df.dateFormat = "dd.MM. HH:mm"
        return df.string(from: date)
    }
}

#Preview {
    let raceResultViewModel = RaceResultViewModel()
    raceResultViewModel.race = Race(
        season: "2025",
        round: "1",
        raceName: "Australian Grand Prix",
        date: "2025-03-16",
        results: [
            Result(
                number: "33",
                position: "1",
                points: "25",
                driver: RaceResultDriver(driverId: "max_verstappen", givenName: "Max", familyName: "Verstappen"),
                constructor: RaceResultConstructor(constructorId: "red_bull", name: "Red Bull Racing")
            )
        ],
        circuit: Circuit(circuitId: "albert_park", circuitName: "Albert Park Grand Prix Circuit")
    )
    
    let raceScheduleViewModel = RaceScheduleViewModel()
    raceScheduleViewModel.raceSchedule = RaceSchedule(
        season: "2025",
        round: "1",
        raceName: "Australian Grand Prix",
        date: "2025-03-16",
        time: "04:00:00Z",
        Circuit: RaceCircuitSchedule(circuitId: "albert_park", circuitName: "Albert Park Grand Prix Circuit"),
        FirstPractice: PracticeSession(date: "2025-03-14", time: "01:30:00Z"),
        SecondPractice: PracticeSession(date: "2025-03-14", time: "05:00:00Z"),
        ThirdPractice: nil,
        Qualifying: PracticeSession(date: "2025-03-15", time: "05:00:00Z"),
        SprintQualifying: PracticeSession(date: "2025-03-21", time: "07:30:00Z"),
        Sprint: PracticeSession(date: "2025-03-22", time: "03:00:00Z")
    )
    
    let qualifyingViewModel = QualifyingViewModel()
    qualifyingViewModel.qualifyingPosition = "1"
    qualifyingViewModel.lapTime = "1:20.123"
    
    let driverStandingsViewModel = DriverStandingsViewModel()
    driverStandingsViewModel.championshipPosition = "1"
    
    let homeViewModel = HomeViewModel()
    homeViewModel.driver = Driver(
        driverId: "max_verstappen",
        permanentNumber: "33",
        code: "VER",
        url: "https://en.wikipedia.org/wiki/Max_Verstappen",
        givenName: "Max",
        familyName: "Verstappen",
        dateOfBirth: "1997-09-30",
        nationality: "Dutch"
    )
    
    return RaceDetailsView(
        raceResultViewModel: raceResultViewModel,
        raceScheduleViewModel: raceScheduleViewModel,
        qualifyingViewModel: qualifyingViewModel,
        driverStandingsViewModel: driverStandingsViewModel,
        viewModel: homeViewModel,
        favoriteDriverId: .constant("max_verstappen"),
        selectedTimeZone: .constant(.current)
    )
}
#Preview {
    let raceScheduleViewModel = RaceScheduleViewModel()
    raceScheduleViewModel.raceSchedule = RaceSchedule(
        season: "2025",
        round: "2",
        raceName: "Chinese Grand Prix",
        date: "2025-03-23",
        time: "07:00:00Z",
        Circuit: RaceCircuitSchedule(circuitId: "shanghai", circuitName: "Shanghai International Circuit"),
        FirstPractice: PracticeSession(date: "2025-03-21", time: "03:30:00Z"),
        SecondPractice: nil,
        ThirdPractice: nil,
        Qualifying: PracticeSession(date: "2025-03-22", time: "07:00:00Z"),
        SprintQualifying: PracticeSession(date: "2025-03-21", time: "07:30:00Z"),
        Sprint: PracticeSession(date: "2025-03-22", time: "03:00:00Z")
    )
    
    return RaceDetailsView(
        raceResultViewModel: RaceResultViewModel(),
        raceScheduleViewModel: raceScheduleViewModel,
        qualifyingViewModel: QualifyingViewModel(),
        driverStandingsViewModel: DriverStandingsViewModel(),
        viewModel: HomeViewModel(),
        favoriteDriverId: .constant("max_verstappen"),
        selectedTimeZone: .constant(.current)
    )
}
