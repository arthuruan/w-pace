//
//  AddWorkoutViewModel.swift
//  WPace
//
//  Created by Arthur Ruan on 17/05/24.
//

import SwiftUI
import WorkoutKit

// TODO: Create form params here
final class NewRoutineViewModel: ObservableObject {
    @Published var isShowNewWorkoutBlockView = false
    @Published var isShowNewWorkoutView = false
    @Published var warmup: Workout?
    @Published var blocks: [WorkoutBlock] = []
    @Published var cooldown: Workout?
    
    func appendBlock() {
        blocks.append(WorkoutBlock(repetition: 3, workouts: workouts))
    }
    
    func addWarmup(_warmup: Workout) {
        warmup = _warmup
    }
    
    func addCooldown(_cooldown: Workout) {
        cooldown = _cooldown
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
        
        
        let customWorkout = CustomWorkout(activity: .running,
                                          location: .outdoor,
                                          displayName: "Corridinha leve",
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
