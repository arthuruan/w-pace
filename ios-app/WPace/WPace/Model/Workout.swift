//
//  Workout.swift
//  WPace
//
//  Created by Arthur Ruan on 25/06/24.
//

import Foundation

enum WorkoutType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case workout
    case recovery
}

enum DurationType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case distance
    case time
}

enum TargetType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }

    case pace
    case heartRate
}

struct Workout: Hashable {    
    let type: WorkoutType
    let durationType: DurationType
    let duration: Double
    let targetType: TargetType
    let low: Double
    let high: Double
}
