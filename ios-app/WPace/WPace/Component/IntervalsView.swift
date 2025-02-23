//
//  Intervals.swift
//  WPace
//
//  Created by Arthur Ruan on 29/06/24.
//

import SwiftUI

// TODO: update this component to be more dynamic
struct IntervalsView: View {
    @Binding var warmup: Workout?
    @Binding var sessions: [WorkoutSession]
    @Binding var cooldwon: Workout?
    
    var body: some View {
        if (warmup != nil) {
            VStack(alignment: .leading) {
                Text("Warmup").bold()
                Text("for \(warmup!.formatWorkoutDuration())").font(.caption)
            }
        }
        ForEach(Array(sessions.enumerated()), id: \.element) { index, session in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Session \(index + 1)").bold()
                    }
                    VStack(alignment: .leading) {
                        ForEach(session.workouts, id: \.self) { workout in
                            Text("\(workout.type.rawValue), for \(workout.formatWorkoutDuration())").font(.caption)
                        }
                    }
                }
                Spacer()
                Text("x\(session.repetition)")
                    .font(.caption)
                    .bold()
                    .padding(6)
                    .background(.wpPrimary)
                    .cornerRadius(8)
                    .foregroundStyle(.black)
            }
            
        }
        if (cooldwon != nil) {
            VStack(alignment: .leading) {
                Text("Cooldown").bold()
                Text("for \(cooldwon!.formatWorkoutDuration())").font(.caption)
            }
        }
    }
}

