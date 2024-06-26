//
//  AddWorkoutBlockView.swift
//  WPace
//
//  Created by Arthur Ruan on 20/05/24.
//

import SwiftUI

enum BlockType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case warmup
    case workout
    case cooldwon
}

struct NewWorkoutBlockView: View {
    @Binding var isShowNewWorkoutBlockView: Bool
    
    @ObservedObject var viewModel = NewWorkoutBlockViewModel()
    
    @State private var type: BlockType = BlockType.workout
    @State private var repetition = 1
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button("Cancel") {
                        isShowNewWorkoutBlockView = false
                    }.foregroundColor(.wpPrimary)
                    Spacer()
                    Text("New Block")
                        .font(.headline)
                    Spacer()
                    Button("Done") {
                     // TODO: Add block
                    }.foregroundColor(.wpPrimary)
                }.padding()
                Form {
                    Picker("Type", selection: $type) {
                        ForEach(BlockType.allCases, id: \.self) { activity in
                            Text(activity.rawValue.capitalized)
                        }
                    }
                    
                    if (type == .workout) {
                        Section {
                            Stepper("Repetition x\(repetition)",
                                        value: $repetition,
                                    in: 1...99)
                        }

                    }
                    
                    Button("Add Workout") {
                        viewModel.isShowNewWorkoutView = true
                    }.foregroundColor(.wpPrimary)
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowNewWorkoutView) {
                NewWorkoutView(isShowNewWorkoutView: $viewModel.isShowNewWorkoutView)
            }
        }
    }
    
}
