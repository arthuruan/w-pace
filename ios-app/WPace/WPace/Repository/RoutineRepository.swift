//
//  RoutineRepository.swift
//  WPace
//
//  Created by Arthur Florentino on 22/02/25.
//

import SwiftUI

class RoutineRepository: ObservableObject {
    // Routine
    @Published var displayName: String = ""
    @Published var workoutDate: Date = .now
    @Published var activity: Activity = .running
    @Published var location: Location = .outdoor
    
    // Workout
    @Published var warmup: Workout?
    @Published var cooldown: Workout?
    
    // Workout Session
    @Published var sessions: [WorkoutSession] = []
    
    @Published var tempSession: WorkoutSession = WorkoutSession(repetition: 1, workouts: [])
    
    func appendTempSessionWorkouts(_ workout: Workout) {
        tempSession.workouts.append(workout)
    }
    
    func resetTempSessionWorkouts() {
        tempSession.workouts.removeAll()
    }
    
    func addWarmup(_ warmup: Workout) {
        self.warmup = warmup
    }
       
    func addCooldown(_ cooldown: Workout) {
        self.cooldown = cooldown
    }
       
    func appendSession(_ session: WorkoutSession) {
        self.sessions.append(session)
    }
    
    func fieldValidation() -> Bool {
        return (displayName != "") && (sessions.count != 0)
    }
    
    func clear() {
        displayName = ""
        workoutDate = .now
        activity = .running
        location = .outdoor
        warmup = nil
        cooldown = nil
        sessions.removeAll()
    }
}
