//
//  AddWorkoutView.swift
//  WPace
//
//  Created by Arthur Ruan on 17/05/24.
//

import SwiftUI

struct NewRoutineView: View {
    @EnvironmentObject var routineRepository: RoutineRepository
    @ObservedObject var viewModel = NewRoutineViewModel()
    @Binding var isShowNewRoutineView: Bool
    @State var isShowNewWorkoutView = false
    @State var isShowNewWorkoutSessionView = false
    
    @State private var navigationWorkoutType: NavigationWorkoutType = .standard
    
    @State private var workoutDate: Date = Date.now
    
    @FocusState private var fieldIsFocused: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    func isRoutineValid() -> Bool {
        return routineRepository.fieldValidation()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    List {
                        TextField("Routine Title", text: $routineRepository.displayName).focused($fieldIsFocused)
                        DatePicker(
                            "Date",
                            selection: $routineRepository.workoutDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .accentColor(.wpPrimary)
                        .datePickerStyle(.automatic)
                        
                        Section("Activity") {
                            Picker("Type", selection: $routineRepository.activity) {
                                ForEach(Activity.allCases, id: \.self) { activity in
                                    Text(activity.rawValue.capitalized)
                                }
                            }
                            Picker("Location", selection: $routineRepository.location) {
                                ForEach(Location.allCases, id: \.self) { location in
                                    Text(location.rawValue.capitalized)
                                }
                            }
                        }
                        
                        if(routineRepository.warmup != nil || routineRepository.sessions.count != 0 || routineRepository.cooldown != nil) {
                            Section("Intervals") {
                                IntervalsView(warmup: $routineRepository.warmup, sessions: $routineRepository.sessions, cooldwon: $routineRepository.cooldown)
                            }
                        }
                        
                        Section("Add Intervals") {
                                HStack {
                                    Text("Warmup").onTapGesture { 
                                        navigationWorkoutType = .warmup
                                        isShowNewWorkoutView = true
                                    }
                                    .disabled(routineRepository.warmup != nil)
                                    .foregroundStyle(routineRepository.warmup != nil ? .gray : .primary)
                                    Spacer()
                                    Text("Session").onTapGesture {
                                        isShowNewWorkoutSessionView = true
                                    }.foregroundStyle(.wpPrimary)
                                    Spacer()
                                    Text("Cooldown").onTapGesture {
                                        navigationWorkoutType = .cooldown
                                        isShowNewWorkoutView = true
                                    }
                                    .disabled(routineRepository.cooldown != nil)
                                    .foregroundStyle(routineRepository.cooldown != nil ? .gray : .primary)
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
        .navigationTitle("New Routine")
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {
                    Task {
                        await viewModel.scheduleWorkout(routineRepository: routineRepository)
                        routineRepository.clear()
                        isShowNewRoutineView = false
                    }
                }
                .disabled(!isRoutineValid())
                .foregroundColor(isRoutineValid() ? .wpPrimary : .gray)
                .bold(isRoutineValid())
            }
        }
        .sheet(isPresented: $isShowNewWorkoutSessionView) {
            NewWorkoutSessionView(isShowNewWorkoutSessionView: $isShowNewWorkoutSessionView)
        }
        .sheet(isPresented: $isShowNewWorkoutView) {
            NewWorkoutView(
                isShowNewWorkoutView: $isShowNewWorkoutView,
                navigationWorkoutType: $navigationWorkoutType
            )
        }
        
    }
}

#Preview {
    NewRoutineView(isShowNewRoutineView: .constant(false))
}
