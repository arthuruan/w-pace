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

struct NewRoutineView: View {
    @ObservedObject var viewModel = NewRoutineViewModel()
    @Binding var isShowNewRoutineView: Bool
    
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
                        Section("Blocks") {
                            Button("Add Workout Block") {
                                viewModel.isShowNewWorkoutBlockView = true
                            }.foregroundColor(.wpPrimary)
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
        .navigationTitle("New Routine")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    Task {
                        await viewModel.scheduleWorkout()
                        isShowNewRoutineView = false
                    }
                }.foregroundColor(.wpPrimary)
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isShowNewWorkoutBlockView) {
            NewWorkoutBlockView(isShowNewWorkoutBlockView: $viewModel.isShowNewWorkoutBlockView)
        }
    }
}

#Preview {
    NewRoutineView(isShowNewRoutineView: .constant(false))
}
