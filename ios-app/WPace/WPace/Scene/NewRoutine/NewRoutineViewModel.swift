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

// TODO: Create form params here
final class NewRoutineViewModel: ObservableObject {
    @Published var isShowNewWorkoutBlockView = false
    @Published var isShowNewWorkoutView = false
    
    @Published var displayName: String = ""
    @Published var workoutDate: Date = .now
    @Published var activity: Activity = .running
    @Published var location: Location = .outdoor
    
    @Published var warmup: Workout?
    @Published var blocks: [WorkoutBlock] = []
    @Published var cooldown: Workout?
    
    func appendBlock(block: WorkoutBlock) {
        blocks.append(block)
    }
    
    func setWarmup(_warmup: Workout) {
        warmup = _warmup
    }
    
    func setCooldown(_cooldown: Workout) {
        cooldown = _cooldown
    }
    
    func fieldValidation() -> Bool {
        return (displayName != "") && (blocks.count != 0 || warmup != nil || cooldown != nil)
    }
    
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
    
    func scheduleWorkout() async {
        var tempoStep = IntervalStep(.work)
        tempoStep.step.goal = .time(40, .minutes)
        tempoStep.step.alert = .speed(8.275...8.784, unit: .kilometersPerHour, metric: .current)
        
        var block = IntervalBlock()
    
        block.steps = [
            tempoStep,
        ]
        block.iterations = 1
        
        
        let customWorkout = CustomWorkout(activity: mapActivityType(activity: activity),
                                          location: mapLocation(location: location),
                                          displayName: displayName,
                                          blocks: [block])
        let workout = WorkoutPlan(.custom(customWorkout))
        
        let daysAheadComponents = DateComponents()
        guard let nextDate = Calendar.autoupdatingCurrent.date(byAdding: daysAheadComponents, to: .now) else {
            return
        }
        let nextDateComponents = Calendar.autoupdatingCurrent.dateComponents(in: .autoupdatingCurrent, from: nextDate)
        await WorkoutScheduler.shared.schedule(workout, at: nextDateComponents)
    }
    
}
