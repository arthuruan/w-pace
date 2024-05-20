//
//  HomeViewModel.swift
//  WPace
//
//  Created by Arthur Ruan on 16/05/24.
//

import SwiftUI
import WorkoutKit
import HealthKit

@MainActor
final class HomeViewModel: ObservableObject {
    var authorizationState: WorkoutScheduler.AuthorizationState = .notDetermined
    @Published var workouts: [ScheduledWorkoutPlan] = []
    @Published var isShowCreateWorkoutView = false {
        didSet {
            if self.isShowCreateWorkoutView == false {
                Task {
                    await fetchWorkouts()
                }
            }
        }
    }
    
    func firstLoad() async {
        await verifyAppleWatchAuth()
        await fetchWorkouts()
    }
    
    func verifyAppleWatchAuth() async {
        if authorizationState != .authorized {
            authorizationState = await WorkoutScheduler.shared.requestAuthorization()
        }
    }
    
    func fetchWorkouts() async {
        workouts = await WorkoutScheduler.shared.scheduledWorkouts
    }
    
    func deleteWorkoutPlan(scheduledWorkout: ScheduledWorkoutPlan) async {
        await WorkoutScheduler.shared.remove(scheduledWorkout.plan, at: scheduledWorkout.date)
        await fetchWorkouts()
    }
}
