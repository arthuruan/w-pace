//
//  NewWorkoutView.swift
//  WPace
//
//  Created by Arthur Ruan on 23/06/24.
//

import SwiftUI

enum DurationType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case distance
    case time
}

enum TargetType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case pace
    case heartRate
}

struct NewWorkoutView: View {
    @Binding var isShowNewWorkoutView: Bool
    
    @State private var durationType: DurationType = DurationType.distance
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
                    Section {
                        Picker("Duration Type", selection: $durationType) {
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
                    
                    Section {
                        Picker("Target Type", selection: $targetType) {
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
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        fieldIsFocused = false
                    }.foregroundColor(.wpPrimary)
                 }
            }
        }
        .navigationTitle("New Workout")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    Task {
                        isShowNewWorkoutView = false
                    }
                }.foregroundColor(.wpPrimary)
            }
        }
    }
}
