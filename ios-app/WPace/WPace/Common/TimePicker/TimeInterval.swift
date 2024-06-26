//
//  TimeInterval.swift
//  WPace
//
//  Created by Arthur Ruan on 19/05/24.
//

import Foundation

extension TimeInterval {
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
    
    func convertPace() -> String {
        let minutes = (Int(self) % 3600) / 60
        let seconds = Int(self) % 60
        
        var minLabel = ""
        var secLabel = ""
        
        if (minutes > 0) {
            minLabel = "\(minutes)'"
        }
        secLabel = "\(seconds)\""
        
        return String("\(minLabel) \(secLabel)")
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
