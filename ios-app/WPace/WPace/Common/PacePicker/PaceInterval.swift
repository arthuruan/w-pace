//
//  PaceInterval.swift
//  WPace
//
//  Created by Arthur Ruan on 22/06/24.
//

import Foundation

struct PaceInterval: TimeInterval {
    func convert() -> String {
        let hours = Int(self) / 3600
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        
        var hrLabel = ""
        var minLabel = ""
        var secLabel = ""
        
        if (hours > 0) {
            hrLabel = "\(hours) hr"
        }
        if (minutes > 0) {
            minLabel = "\(minutes) min"
        }
        secLabel = "\(seconds) s"
        
        return String("\(hrLabel) \(minLabel) \(secLabel)")
    }
    func toHour() -> Int {
        return Int(self) / 3600
    }
    func toMinute() -> Int {
        return (Int(self) % 3600) / 60
    }
    func toSecond() -> Int {
        return Int(self) % 60
    }
}
