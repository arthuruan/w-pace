//
//  AddWorkoutBlockViewModel.swift
//  WPace
//
//  Created by Arthur Ruan on 22/06/24.
//

import Foundation


final class NewWorkoutBlockViewModel: ObservableObject {
    @Published var isShowNewWorkoutView = false
    @Published var repetition = 1
    @Published var workouts: [Workout] = []
    
    func appendWorkout(workout: Workout) {
        workouts.append(workout)
    }
}
