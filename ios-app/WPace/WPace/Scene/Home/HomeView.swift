//
//  HomeView.swift
//  WPace
//
//  Created by Arthur Ruan on 16/05/24.
//

import SwiftUI
import WorkoutKit

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @StateObject private var routineRepository = RoutineRepository()
    
    let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named
        return formatter
    }()
    
    func delete(at offsets: IndexSet) async {
        let workout = viewModel.workouts[offsets.first!]
        await viewModel.deleteWorkoutPlan(scheduledWorkout: workout)
        viewModel.workouts.remove(atOffsets: offsets)
    }
 
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    ForEach($viewModel.workouts, id: \.self) { $workout in
                        VStack(alignment: .leading) {
                            if let scheduledDate = Calendar.autoupdatingCurrent.date(from: workout.date) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(workout.plan.workout.displayName).bold()
                                            
                                            let relativeDate = dateFormatter.localizedString(for: scheduledDate, relativeTo: .now)
                                            Text(relativeDate)
                                                .font(.caption)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }.onDelete{ index in
                        Task {
                            await delete(at: index)
                        }
                    }
                }
            }
            .navigationTitle("Routines")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowNewRoutineView = true
                    } label: {
                        Image("wp-button-icon").resizable().frame(width: 27, height: 27)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowNewRoutineView) {
                NewRoutineView(isShowNewRoutineView: $viewModel.isShowNewRoutineView)
                    .environmentObject(routineRepository)

            }
        }
        .tint(.wpPrimary)
        .task {
            await viewModel.firstLoad()
        }
        .refreshable {
            await viewModel.fetchWorkouts()
        }
    }
}

#Preview {
    HomeView()
}
