//
//  AddWorkoutSessionView.swift
//  WPace
//
//  Created by Arthur Ruan on 20/05/24.
//

import SwiftUI

struct NewWorkoutSessionView: View {
    @EnvironmentObject var routineRepository: RoutineRepository
    @State var isShowNewWorkoutView = false
    
    @Binding var isShowNewWorkoutSessionView: Bool
    
    func isWorkoutsEmpty() -> Bool {
        return routineRepository.tempSession.workouts.isEmpty
    }
        
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Stepper("Repeated x\(routineRepository.tempSession.repetition)",
                                value: $routineRepository.tempSession.repetition,
                                in: 1...99)
                    }
                    
                    Section{
                        ForEach(routineRepository.tempSession.workouts, id: \.self) { workout in
                            VStack(alignment: .leading) {
                                Text(workout.type.rawValue.capitalized).bold()
                                Text("for \(workout.formatWorkoutDuration())").font(.caption)
                            }
                        }
                    }
                    
                    Button("Add Workout") {
                        isShowNewWorkoutView = true
                    }.foregroundColor(.wpPrimary)
                }
            }
            .navigationTitle("Session")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        isShowNewWorkoutSessionView = false
                        routineRepository.appendSession(WorkoutSession(repetition: routineRepository.tempSession.repetition, workouts: routineRepository.tempSession.workouts))
                        routineRepository.resetTempSessionWorkouts()
                    }
                    .disabled(isWorkoutsEmpty())
                    .foregroundColor(isWorkoutsEmpty() ? .gray : .wpPrimary)
                    .bold(!isWorkoutsEmpty())

                }
            }
            .navigationDestination(isPresented: $isShowNewWorkoutView) {
                NewWorkoutView(
                    isShowNewWorkoutView: $isShowNewWorkoutView,
                    navigationWorkoutType: .constant(.standard)
                )
            }
        }
    }
    
}

#Preview {
    NewWorkoutSessionView(isShowNewWorkoutSessionView: .constant(false))
}
