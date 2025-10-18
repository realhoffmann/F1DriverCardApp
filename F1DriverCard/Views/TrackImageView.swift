import SwiftUI

struct TrackImageView: View {
    @ObservedObject var raceResultViewModel: RaceResultViewModel
    @ObservedObject var raceScheduleViewModel: RaceScheduleViewModel
    @Binding var dragOffset: CGFloat
    let updateRaceData: () async -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundStyle(.gray)
                .frame(height: 44)
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dragOffset = 500
                        }
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        await raceResultViewModel.fetchPreviousRace()
                        raceScheduleViewModel.fetchPreviousRaceSchedule()
                        await updateRaceData()
                        dragOffset = -500
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dragOffset = 0
                        }
                    }
                }
            Spacer()
            Image(raceScheduleViewModel.trackImage)
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragOffset = gesture.translation.width
                    }
                    .onEnded { gesture in
                        let threshold: CGFloat = 50
                        if gesture.translation.width > threshold {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                dragOffset = 500
                            }
                            Task {
                                try? await Task.sleep(nanoseconds: 300_000_000)
                                await raceResultViewModel.fetchPreviousRace()
                                raceScheduleViewModel.fetchPreviousRaceSchedule()
                                await updateRaceData()
                                dragOffset = -500
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    dragOffset = 0
                                }
                            }
                        } else if gesture.translation.width < -threshold {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                dragOffset = -500
                            }
                            Task {
                                try? await Task.sleep(nanoseconds: 300_000_000)
                                await raceResultViewModel.fetchNextRace()
                                raceScheduleViewModel.fetchNextRaceSchedule()
                                await updateRaceData()
                                dragOffset = 500
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    dragOffset = 0
                                }
                            }
                        } else {
                            withAnimation {
                                dragOffset = 0
                            }
                        }
                    }
            )
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
                .frame(height: 44)
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dragOffset = -500
                        }
                        try? await Task.sleep(nanoseconds: 300_000_000)
                        await raceResultViewModel.fetchNextRace()
                        raceScheduleViewModel.fetchNextRaceSchedule()
                        await updateRaceData()
                        dragOffset = 500
                        withAnimation(.easeInOut(duration: 0.3)) {
                            dragOffset = 0
                        }
                    }
                }
        }
    }
}

#Preview {
    TrackImageView(
        raceResultViewModel: RaceResultViewModel(),
        raceScheduleViewModel: RaceScheduleViewModel(),
        dragOffset: .constant(0),
        updateRaceData: {}
    )
}
