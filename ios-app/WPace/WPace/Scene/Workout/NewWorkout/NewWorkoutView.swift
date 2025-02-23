//
//  NewWorkoutView.swift
//  WPace
//
//  Created by Arthur Ruan on 23/06/24.
//

import SwiftUI

enum NavigationWorkoutType {
    case warmup
    case cooldown
    case standard
}


func getNavigationTitle(type: NavigationWorkoutType) -> String {
    switch (type) {
    case .cooldown:
        return "Cooldwon"
    case .standard:
        return "Workout"
    case .warmup:
        return "Warmup"
    }
}

struct NewWorkoutView: View {
    @EnvironmentObject var routineRepository: RoutineRepository
    @Binding var isShowNewWorkoutView: Bool
    @Binding var navigationWorkoutType: NavigationWorkoutType
    
    @State private var type: WorkoutType = .steady
    @State private var durationType: DurationType = .distance
    @State private var durationTime: TimeInterval = 60
    @State private var durationDistance: Double = 1
    @State private var targetType: TargetType = TargetType.pace
    @State private var slowest: TimeInterval = 360
    @State private var fastest: TimeInterval = 300
    
    @FocusState private var fieldIsFocused: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    if (navigationWorkoutType == .standard) {
                        Section ("Workout") {
                            Picker("Type", selection: $type) {
                                ForEach(WorkoutType.allCases, id: \.self) { activity in
                                    Text(activity.rawValue.capitalized)
                                }
                            }
                        }
                    }
        
                    Section ("Duration") {
                        Picker("Type", selection: $durationType) {
                            ForEach(DurationType.allCases, id: \.self) { activity in
                                Text(activity.rawValue.capitalized)
                            }
                        }
                        switch(durationType) {
                        case .time:
                            TimerPicker(timeInterval: $durationTime, title: "Duration", columnType: .hours)
                        case .distance:
                            LabeledContent {
                                TextField("-", value: $durationDistance, formatter: formatter)
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .focused($fieldIsFocused)
                            } label: {
                                Text("Duration (km)")
                            }
                        }
                    }
                    Section("Target") {
                        Picker("Type", selection: $targetType) {
                            ForEach(TargetType.allCases, id: \.self) { activity in
                                let text: String = activity == TargetType.heartRate ? "Heart Rate" : activity.rawValue.capitalized
                                Text(text)
                            }
                        }
                        switch(targetType) {
                        case .pace:
                            TimerPicker(timeInterval: $slowest, title: "Slowest Pace", pickerType: .pace)
                            TimerPicker(timeInterval: $fastest, title: "Fastest Pace", pickerType: .pace)
                        case .heartRate:
                            Picker("Low BPM", selection: $slowest) {
                                ForEach(0..<249) {
                                    Text("\($0) BPM")
                                }
                            }
                            Picker("High BPM", selection: $fastest) {
                                ForEach(0..<249) {
                                    Text("\($0) BPM")
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(getNavigationTitle(type: navigationWorkoutType))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        isShowNewWorkoutView = false
                        var duration = Double(durationDistance)
                        if (durationType == .time) {
                            duration = Double(durationTime)
                        }
                        
                        switch navigationWorkoutType {
                        case .warmup:
                            routineRepository.addWarmup(Workout(type: type, durationType: durationType, duration: duration, targetType: targetType, low: slowest, high: fastest))
                        case .cooldown:
                            routineRepository.addCooldown(Workout(type: type, durationType: durationType, duration: duration, targetType: targetType, low: slowest, high: fastest))
                        case .standard:
                            routineRepository.appendTempSessionWorkouts(Workout(type: type, durationType: durationType, duration: duration, targetType: targetType, low: slowest, high: fastest))
                            break
                        }
                        
                        
                    }.foregroundColor(.wpPrimary).bold()
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        fieldIsFocused = false
                    }.foregroundColor(.wpPrimary).bold()
                 }
            }
        }
    }
}

#Preview {
    NewWorkoutView(
        isShowNewWorkoutView: .constant(false),
        navigationWorkoutType: .constant(NavigationWorkoutType.cooldown)
    )
}
