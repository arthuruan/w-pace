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
    @Binding var isShowNewWorkoutBlockView: Bool
    
    @ObservedObject var viewModel = NewWorkoutBlockViewModel()
    
    @State private var repetition = 1
        
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        Stepper("Repeated x\(repetition)",
                                value: $repetition,
                                in: 1...99)
                    }
                    
                    Button("Add Workout") {
                        viewModel.isShowNewWorkoutView = true
                    }.foregroundColor(.wpPrimary)
                    
                    Section{
                        ForEach(workouts, id: \.self) { workout in
                            HStack {
                                Text(workout.durationType.rawValue.capitalized)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Block")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isShowNewWorkoutBlockView = false
                    }.foregroundColor(.wpPrimary).bold()
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowNewWorkoutView) {
                NewWorkoutView(isShowNewWorkoutView: $viewModel.isShowNewWorkoutView, aaa: .constant(.standard))
            }
        }
    }
    
}
