//
//  AddWorkoutView.swift
//  WPace
//
//  Created by Arthur Ruan on 17/05/24.
//

import SwiftUI

enum Activity: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case running
}

enum Location: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case outdoor
    case indoor
    case unknown
}

let warmup: Workout = Workout(type: .recovery, durationType: .distance, duration: 5, targetType: .heartRate, low: 160, high: 180)
let blocks: [WorkoutBlock] = [
    WorkoutBlock(repetition: 3, workouts: workouts),
    WorkoutBlock(repetition: 5, workouts: workouts)
]

struct NewRoutineView: View {
    @ObservedObject var viewModel = NewRoutineViewModel()
    @Binding var isShowNewRoutineView: Bool
    
    @State private var navigationWorkoutType: NavigationWorkoutType = .standard
    
    @State private var displayName: String = ""
    @State private var workoutDate: Date = Date.now
    @State private var activity: Activity = Activity.running
    @State private var location: Location = Location.outdoor
    
    @FocusState private var fieldIsFocused: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Form {
                        TextField("Routine Title", text: $displayName).focused($fieldIsFocused)
                        DatePicker(
                            "Date",
                            selection: $workoutDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .accentColor(.wpPrimary)
                        .datePickerStyle(.automatic)
                        
                        Section("Activity") {
                            Picker("Type", selection: $activity) {
                                ForEach(Activity.allCases, id: \.self) { activity in
                                    Text(activity.rawValue.capitalized)
                                }
                            }
                            Picker("Location", selection: $location) {
                                ForEach(Location.allCases, id: \.self) { location in
                                    Text(location.rawValue.capitalized)
                                }
                            }
                        }
                        
                        // TODO: List recovery, blocks and cooldown
                        Section("Intervals") {
                            VStack(alignment: .leading) {
                                Text("Warmup").bold()
                                Text("for 5 min").font(.caption)
                            }
                            ForEach(blocks, id: \.self) { block in
                                HStack(alignment: .center) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("Block 1").bold()
                                        }
                                        VStack(alignment: .leading) {
                                            ForEach(block.workouts, id: \.self) { workout in
                                                Text("\(workout.type.rawValue), for 5 min").font(.caption)
                                            }
                                        }
                                    }
                                    Spacer()
                                    Text("x\(block.repetition)")
                                        .font(.caption)
                                        .bold()
                                        .padding(6)
                                        .background(.wpPrimary)
                                        .cornerRadius(8)
                                        .foregroundStyle(.black)
                                }
                              
                            }
                            VStack(alignment: .leading) {
                                Text("Cooldown").bold()
                                Text("for 5 min").font(.caption)
                            }
                        }
                        
                        Section("Add Intervals") {
                      
                                HStack {
                                    Text("Warmup").onTapGesture { 
                                        navigationWorkoutType = .warmup
                                        viewModel.isShowNewWorkoutView = true
                                    }
                                    Spacer()
                                    Text("Block").onTapGesture {
                                        viewModel.isShowNewWorkoutBlockView = true
                                    }.foregroundStyle(.wpPrimary)
                                    Spacer()
                                    Text("Cooldown").onTapGesture {
                                        navigationWorkoutType = .cooldown
                                        viewModel.isShowNewWorkoutView = true
                                    }.disabled(true).foregroundStyle(.gray) // TODO: move the color to a state that changes when its have the interval already
                                }
                         
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                       fieldIsFocused = false
                    }.foregroundColor(.wpPrimary)
                 }
            }
        }
        .navigationTitle("New Routine")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    Task {
                        await viewModel.scheduleWorkout()
                        isShowNewRoutineView = false
                    }
                }.foregroundColor(.wpPrimary).bold()
            }
        }
        .sheet(isPresented: $viewModel.isShowNewWorkoutBlockView) {
            NewWorkoutBlockView(isShowNewWorkoutBlockView: $viewModel.isShowNewWorkoutBlockView)
        }
        .sheet(isPresented: $viewModel.isShowNewWorkoutView) {
            NewWorkoutView(isShowNewWorkoutView: $viewModel.isShowNewWorkoutView, navigationWorkoutType: $navigationWorkoutType)
        }
        
    }
}

#Preview {
    NewRoutineView(isShowNewRoutineView: .constant(false))
}
