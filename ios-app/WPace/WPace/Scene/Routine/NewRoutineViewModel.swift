//
//  AddWorkoutViewModel.swift
//  WPace
//
//  Created by Arthur Ruan on 17/05/24.
//

import SwiftUI
import HealthKit
import WorkoutKit

enum Location: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case outdoor
    case indoor
    case unknown
}

enum Activity: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case running
}

final class NewRoutineViewModel: ObservableObject {
    private func mapLocation(location: Location) -> HKWorkoutSessionLocationType {
        switch(location) {
        case .indoor:
            return .indoor
        case .outdoor:
            return .outdoor
        case .unknown:
            return .unknown
        }
    }
    
    private func mapActivityType(activity: Activity) -> HKWorkoutActivityType {
        switch(activity) {
        case .running:
            return .running
        }
    }
    
    func mapWorkoutSessionsToIntervalBlocks(sessions: [WorkoutSession]) -> [IntervalBlock] {
        var intervalBlocks: [IntervalBlock] = []
        
        for session in sessions {
            var intervalBlock = IntervalBlock()
            
            // Loop over each workout in the session
            for workout in session.workouts {
                var intervalStep: IntervalStep = if workout.type == .slow {
                    .init(.recovery)
                } else {
                    .init(.work)
                }
                
                intervalStep.step.goal = workout.getWKGoal()
                intervalStep.step.alert = workout.getWKAlert()
                
                // Map the alert based on targetType (for example, speed or heart rate)
                switch workout.targetType {
                case .pace:
                    intervalStep.step.alert = .speed(workout.getLowKmPerHour()...workout.getHighKmPerHour(), unit: .kilometersPerHour, metric: .current)
                case .heartRate:
                    intervalStep.step.alert = .heartRate(zone: 2)
                }
                
                // Append the created interval step to the block
                intervalBlock.steps.append(intervalStep)
            }
            
            // Set the block iterations
            intervalBlock.iterations = session.repetition
            
            // Append the interval block to the list of blocks
            intervalBlocks.append(intervalBlock)
        }
        
        return intervalBlocks
    }

    func scheduleWorkout(routineRepository: RoutineRepository) async {
        var warmupStep: WorkoutStep?
        if let warmup = routineRepository.warmup {
            var alert: any WorkoutAlert = .speed(warmup.getLowKmPerHour()...warmup.getHighKmPerHour(), unit: .kilometersPerHour, metric: .current)
            if warmup.targetType == .heartRate {
                alert = .heartRate(warmup.getLowKmPerHour()...warmup.getHighKmPerHour())
            }
            
            warmupStep = WorkoutStep(goal: warmup.getWKGoal(), alert: alert)
        }
    
        let blocks = mapWorkoutSessionsToIntervalBlocks(sessions: routineRepository.sessions)
        
        var cooldownStep: WorkoutStep?
        if let cooldown = routineRepository.cooldown {
            var alert: any WorkoutAlert = .speed(cooldown.getLowKmPerHour()...cooldown.getHighKmPerHour(), unit: .kilometersPerHour, metric: .current)
            if cooldown.targetType == .heartRate {
                alert = .heartRate(cooldown.getLowKmPerHour()...cooldown.getHighKmPerHour())
            }
            cooldownStep = WorkoutStep(goal: cooldown.getWKGoal(), alert: alert)
        }
        
        let customWorkout = CustomWorkout(activity: mapActivityType(activity: routineRepository.activity),
                                          location: mapLocation(location: routineRepository.location),
                                          displayName: routineRepository.displayName,
                                          warmup: warmupStep,
                                          blocks: blocks,
                                          cooldown: cooldownStep)
        let workout = WorkoutPlan(.custom(customWorkout))
        
        let daysAheadComponents = DateComponents()
        guard let nextDate = Calendar.autoupdatingCurrent.date(byAdding: daysAheadComponents, to: routineRepository.workoutDate) else {
            return
        }
        let nextDateComponents = Calendar.autoupdatingCurrent.dateComponents(in: .autoupdatingCurrent, from: nextDate)
        await WorkoutScheduler.shared.schedule(workout, at: nextDateComponents)
    }
    
}
