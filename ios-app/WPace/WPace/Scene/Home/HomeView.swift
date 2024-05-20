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
    
    let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.dateTimeStyle = .named
        return formatter
    }()
 
    var body: some View {
        NavigationView {
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
                                .onTapGesture {
                                    Task {
                                        await viewModel.deleteWorkoutPlan(scheduledWorkout: workout)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Routine")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowCreateWorkoutView = true
                    } label: {
                        Image("wp-button-icon").resizable().frame(width: 27, height: 27)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isShowCreateWorkoutView) {
                AddWorkoutView(isShowCreateWorkoutView: $viewModel.isShowCreateWorkoutView)
            }
        }
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
