//
//  NewWorkoutView.swift
//  WPace
//
//  Created by Arthur Ruan on 23/06/24.
//

import SwiftUI

// TODO: change this name
enum WType {
    case warmup
    case cooldown
    case standard
}


func getNavigationTitle(wType: WType) -> String {
    switch (wType) {
    case .cooldown:
        return "New Cooldwon"
    case .standard:
        return "New Workout"
    case .warmup:
        return "New Warmup"
    }
}

struct NewWorkoutView: View {
    @Binding var isShowNewWorkoutView: Bool
    // TODO: change this name
    @Binding var aaa: WType
    
    @State private var type: WorkoutType = .workout
    @State private var durationType: DurationType = .distance
    @State private var duration: TimeInterval = 10
    @State private var distance: Float = 1
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
                    if (aaa == .standard) {
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
                            TimerPicker(timeInterval: $duration, title: "Duration", columnType: .hours)
                        case .distance:
                            LabeledContent {
                                TextField("-", value: $distance, formatter: formatter)
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
            .navigationTitle(getNavigationTitle(wType: aaa))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isShowNewWorkoutView = false
                    }.foregroundColor(.wpPrimary).bold()
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Button("Done") {
                        fieldIsFocused = false
                    }.foregroundColor(.wpPrimary).bold()
                 }
            }
        }
    }
}

#Preview {
    NewWorkoutView(isShowNewWorkoutView: .constant(false), aaa: .constant(WType.cooldown))
}
