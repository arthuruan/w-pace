//
//  Workout.swift
//  WPace
//
//  Created by Arthur Ruan on 25/06/24.
//

import Foundation
import WorkoutKit

enum WorkoutType: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case fast
    case steady
    case slow
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

struct SpeedRangeAlert {
    let range: ClosedRange<Double>
    let unit: UnitSpeed
    let metric: WorkoutAlertMetric
    
    static func speed(_ range: ClosedRange<Double>, unit: UnitSpeed, metric: WorkoutAlertMetric) -> SpeedRangeAlert {
        return SpeedRangeAlert(range: range, unit: unit, metric: metric)
    }
}

struct HeartRateZoneAlert {
    let zone: Int
    
    static func heartRate(zone: Int) -> HeartRateZoneAlert {
        return HeartRateZoneAlert(zone: zone)
    }
}

extension Workout {
    func formatDistance(_ value: Double) -> String {
        if value >= 1 {
            return "\(value) km"
        } else {
            return "\(Int(value * 1000)) m"
        }
    }
        
    func formatTime(_ value: Double) -> String {
        let hours = Int(value) / 3600
        let minutes = (Int(value) % 3600) / 60
        let seconds = Int(value) % 60
        
        var timeString = ""
        
        if hours > 0 {
            timeString += "\(hours) hr "
        }
        
        if minutes > 0 {
            timeString += "\(minutes) min "
        }
        
        if seconds > 0 || (hours == 0 && minutes == 0) {
            timeString += "\(seconds) sec"
        }
        
        return timeString.trimmingCharacters(in: .whitespaces)
    }

    func formatWorkoutDuration() -> String {
        switch durationType {
        case .distance:
            return formatDistance(duration)
        case .time:
            return formatTime(duration)
        }
    }
    
    // Workout Kit mapping
    
    func getLowKmPerHour() -> Double {
        return 3600 / low
    }
    
    func getHighKmPerHour() -> Double {
        return 3600 / high
    }
    
    func getWKGoal() -> WorkoutGoal {
        switch durationType {
        case .distance:
            return WorkoutGoal.distance(duration, .kilometers)
        case .time:
            return WorkoutGoal.time(duration, .seconds)
        }
    }
    
    func getWKAlert() -> (any WorkoutAlert)? {
        switch targetType {
        case .pace:
            return SpeedRangeAlert.speed(getLowKmPerHour()...getHighKmPerHour(), unit: .kilometersPerHour, metric: .current) as? any WorkoutAlert
        case .heartRate:
            return HeartRateZoneAlert.heartRate(zone: 1) as? any WorkoutAlert
        }
    }
}
