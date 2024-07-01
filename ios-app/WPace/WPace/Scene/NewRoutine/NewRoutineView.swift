//
//  AddWorkoutView.swift
//  WPace
//
//  Created by Arthur Ruan on 17/05/24.
//

import SwiftUI

struct NewRoutineView: View {
    @ObservedObject var viewModel = NewRoutineViewModel()
    @Binding var isShowNewRoutineView: Bool
    
    @State private var navigationWorkoutType: NavigationWorkoutType = .standard
    
    @State private var workoutDate: Date = Date.now
    
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
                    List {
                        TextField("Routine Title", text: $viewModel.displayName).focused($fieldIsFocused)
                        DatePicker(
                            "Date",
                            selection: $workoutDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .accentColor(.wpPrimary)
                        .datePickerStyle(.automatic)
                        
                        Section("Activity") {
                            Picker("Type", selection: $viewModel.activity) {
                                ForEach(Activity.allCases, id: \.self) { activity in
                                    Text(activity.rawValue.capitalized)
                                }
                            }
                            Picker("Location", selection: $viewModel.location) {
                                ForEach(Location.allCases, id: \.self) { location in
                                    Text(location.rawValue.capitalized)
                                }
                            }
                        }
                        
                        if(viewModel.warmup != nil || viewModel.blocks.count != 0 || viewModel.cooldown != nil) {
                            Section("Intervals") {
                                IntervalsView(warmup: $viewModel.warmup, blocks: $viewModel.blocks, cooldwon: $viewModel.cooldown)
                            }
                        }
                        
                        Section("Add Intervals") {
                                HStack {
                                    Text("Warmup").onTapGesture { 
                                        navigationWorkoutType = .warmup
                                        viewModel.isShowNewWorkoutView = true
                                    }
                                    .disabled(viewModel.warmup != nil)
                                    .foregroundStyle(viewModel.warmup != nil ? .gray : .black)
                                    Spacer()
                                    Text("Block").onTapGesture {
                                        viewModel.isShowNewWorkoutBlockView = true
                                    }.foregroundStyle(.wpPrimary)
                                    Spacer()
                                    Text("Cooldown").onTapGesture {
                                        navigationWorkoutType = .cooldown
                                        viewModel.isShowNewWorkoutView = true
                                    }
                                    .disabled(viewModel.cooldown != nil)
                                    .foregroundStyle(viewModel.cooldown != nil ? .gray : .black)
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
                        await viewModel.scheduleWorkout()
                        isShowNewRoutineView = false
                    }
                }
                .disabled(!viewModel.fieldValidation())
                .foregroundColor(viewModel.fieldValidation() ? .wpPrimary : .gray)
                .bold(viewModel.fieldValidation())
            }
        }
        .sheet(isPresented: $viewModel.isShowNewWorkoutBlockView) {
            NewWorkoutBlockView(newRoutineViewModel: viewModel, isShowNewWorkoutBlockView: $viewModel.isShowNewWorkoutBlockView)
        }
        .sheet(isPresented: $viewModel.isShowNewWorkoutView) {
            NewWorkoutView(
                newRoutineViewModel: viewModel,
                newWorkoutBlockViewModel: NewWorkoutBlockViewModel(),
                isShowNewWorkoutView: $viewModel.isShowNewWorkoutView,
                navigationWorkoutType: $navigationWorkoutType
            )
        }
        
    }
}

#Preview {
    NewRoutineView(isShowNewRoutineView: .constant(false))
}
