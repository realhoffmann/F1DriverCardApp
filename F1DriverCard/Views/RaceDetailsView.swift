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
                Text(raceResultViewModel.race?.raceName ?? "Unknown")
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
                if let firstPractice = schedule.FirstPractice {
                    HStack {
                        Text("First Practice: ")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(formatDate(firstPractice.date)) \(formatTime(firstPractice.time))")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    }
                    Divider().frame(height: 1).overlay(.gray)
                }
                if let secondPractice = schedule.SecondPractice {
                    HStack {
                        Text("Second Practice: ")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(formatDate(secondPractice.date)) \(formatTime(secondPractice.time))")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    }
                    Divider().frame(height: 1).overlay(.gray)
                } else if let sprintQualifying = schedule.SprintQualifying {
                    HStack {
                        Text("Sprint Qualifying: ")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(formatDate(sprintQualifying.date)) \(formatTime(sprintQualifying.time))")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    }
                    Divider().frame(height: 1).overlay(.gray)
                }
                if let thirdPractice = schedule.ThirdPractice {
                    HStack {
                        Text("Third Practice: ")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(formatDate(thirdPractice.date)) \(formatTime(thirdPractice.time))")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    }
                    Divider().frame(height: 1).overlay(.gray)
                } else if let sprint = schedule.Sprint {
                    HStack {
                        Text("Sprint: ")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(formatDate(sprint.date)) \(formatTime(sprint.time))")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    }
                    Divider().frame(height: 1).overlay(.gray)
                }
                if let qualifying = schedule.Qualifying {
                    HStack {
                        Text("Qualifying: ")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(formatDate(qualifying.date)) \(formatTime(qualifying.time))")
                            .font(.f1Regular(18))
                            .foregroundColor(.white)
                    }
                    Divider().frame(height: 1).overlay(.gray)
                }
                HStack {
                    Text("Race: ")
                        .font(.f1Regular(18))
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(formatDate(schedule.date)) \(formatTime(schedule.time))")
                        .font(.f1Regular(18))
                        .foregroundColor(.white)
                }
                Divider().frame(height: 1).overlay(.gray)
            } else {
                Text("Loading race data...")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }
    
    private func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd.MM."
            return dateFormatter.string(from: date)
        }
        return date
    }
    
    private func formatTime(_ time: String) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss'Z'"
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let time = timeFormatter.date(from: time) {
            timeFormatter.dateFormat = "HH:mm"
            timeFormatter.timeZone = selectedTimeZone
            return timeFormatter.string(from: time)
        }
        return time
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
