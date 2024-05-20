//
//  CreateWorkoutView.swift
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

enum GoalType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case duration
    case distance
    case open
}

struct AddWorkoutView: View {
    @ObservedObject var viewModel = AddWorkoutViewModel()
    @Binding var isShowCreateWorkoutView: Bool
    
    @State private var displayName: String = ""
    @State private var workoutDate: Date = Date.now
    @State private var activity: Activity = Activity.running
    @State private var location: Location = Location.outdoor
    // Wearmup opts
    @State private var warmupOptsIsOn: Bool = false
    @State private var warmupGoal: GoalType = GoalType.duration
    @State private var warmupDuration: TimeInterval = 0
    @State private var warmupDistance: Float?
    // Cooldwon opts
    @State private var cooldownOptsIsOn: Bool = false
    @State private var cooldownGoal: GoalType = GoalType.duration
    @State private var cooldownDuration: TimeInterval = 0
    @State private var cooldownDistance: Float?
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("Cancel") {
                        isShowCreateWorkoutView = false
                    }.foregroundColor(.wpPrimary)
                    Spacer()
                    Text("New Wokout")
                        .font(.headline)
                    Spacer()
                    Button("Add") {
                        Task {
                            await viewModel.scheduleWorkout()
                            isShowCreateWorkoutView = false
                        }
                    }.foregroundColor(.wpPrimary)
                }.padding()
                Spacer()
                Form {
                    TextField("Workout Title", text: $displayName)
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
                    Section("Warmup") {
                        Toggle(isOn: $warmupOptsIsOn) {
                            Text("Warmup")
                        }
                        if warmupOptsIsOn {
                            Picker("Goal", selection: $warmupGoal) {
                                ForEach(GoalType.allCases, id: \.self) { goal in
                                    Text(goal.rawValue.capitalized)
                                }
                            }
                            switch(warmupGoal) {
                            case .duration:
                                TimerPicker(timeInterval: $warmupDuration, title: "Duration", columnType: .minutes)
                            case .distance:
                                LabeledContent {
                                    TextField("-", value: $warmupDistance, formatter: formatter)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                } label: {
                                    Text("Distance (km)")
                                }
                            case .open:
                                EmptyView()
                            }
                        }
                    }
                    Section("Blocks") {
                        Button("Add Workout Block") {}.foregroundColor(.wpPrimary)
                    }
                    Section("Cooldown") {
                        Toggle(isOn: $cooldownOptsIsOn) {
                            Text("Cooldown")
                        }
                        if cooldownOptsIsOn {
                            Picker("Goal", selection: $cooldownGoal) {
                                ForEach(GoalType.allCases, id: \.self) { goal in
                                    Text(goal.rawValue.capitalized)
                                }
                            }
                            switch(cooldownGoal) {
                            case .duration:
                                TimerPicker(timeInterval: $cooldownDuration, title: "Duration", columnType: .minutes)
                            case .distance:
                                LabeledContent {
                                    TextField("-", value: $cooldownDistance, formatter: formatter)
                                        .keyboardType(.decimalPad)
                                        .multilineTextAlignment(.trailing)
                                } label: {
                                    Text("Distance (km)")
                                }
                            case .open:
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }.sheet(isPresented: .constant(false)) {
            HStack {
                Text("Add Workout Block")
            }
        }
    }
}

#Preview {
    AddWorkoutView(isShowCreateWorkoutView: .constant(true))
}
