//
//  AddWorkoutBlockView.swift
//  WPace
//
//  Created by Arthur Ruan on 20/05/24.
//

import SwiftUI



let workouts: [Workout] = [
    Workout(type: .workout, durationType: .distance, duration: 5, targetType: .heartRate, low: 160, high: 180),
    Workout(type: .recovery, durationType: .time, duration: 460, targetType: .pace, low: 160, high: 180),
]

struct NewWorkoutBlockView: View {
    @ObservedObject var viewModel = NewWorkoutBlockViewModel()
    @StateObject var newRoutineViewModel: NewRoutineViewModel
    
    @Binding var isShowNewWorkoutBlockView: Bool
        
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Stepper("Repeated x\(viewModel.repetition)",
                                value: $viewModel.repetition,
                                in: 1...99)
                    }
                    
                    Section{
                        ForEach(viewModel.workouts, id: \.self) { workout in
                            VStack(alignment: .leading) {
                                Text(workout.type.rawValue.capitalized).bold()
                                Text("for 5 min").font(.caption)
                            }
                        }
                    }
                    
                    Button("Add Workout") {
                        viewModel.isShowNewWorkoutView = true
                    }.foregroundColor(.wpPrimary)
                }
            }
            .navigationTitle("Block")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        isShowNewWorkoutBlockView = false
                        newRoutineViewModel.appendBlock(
                            block: WorkoutBlock(repetition: viewModel.repetition, workouts: viewModel.workouts)
                        )
                    }
                    .disabled(viewModel.workouts.count == 0)
                    .foregroundColor(viewModel.workouts.count == 0 ? .gray : .wpPrimary)
                    .bold(viewModel.workouts.count != 0)

                }
            }
            .navigationDestination(isPresented: $viewModel.isShowNewWorkoutView) {
                NewWorkoutView(
                    newRoutineViewModel: newRoutineViewModel,
                    newWorkoutBlockViewModel: viewModel,
                    isShowNewWorkoutView: $viewModel.isShowNewWorkoutView,
                    navigationWorkoutType: .constant(.standard)
                )
            }
        }
    }
    
}

#Preview {
    NewWorkoutBlockView(newRoutineViewModel: NewRoutineViewModel(),isShowNewWorkoutBlockView: .constant(false))
}
