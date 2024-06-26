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
    
    @State private var wType: WType = .standard
    
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
                        Section("Add Intervals") {
                            List {
                                HStack {
                                    Text("Warmup").onTapGesture { 
                                        wType = .warmup
                                        viewModel.isShowNewWorkoutView = true
                                    }
                                    Spacer()
                                    Text("Block").onTapGesture {
                                        viewModel.isShowNewWorkoutBlockView = true
                                    }.foregroundStyle(.wpPrimary)
                                    Spacer()
                                    Text("Cooldown").onTapGesture {
                                        wType = .cooldown
                                        viewModel.isShowNewWorkoutView = true
                                    }
                                }
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
                Button("Done") {
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
            NewWorkoutView(isShowNewWorkoutView: $viewModel.isShowNewWorkoutView, aaa: $wType)
        }
        
    }
}

#Preview {
    NewRoutineView(isShowNewRoutineView: .constant(false))
}
