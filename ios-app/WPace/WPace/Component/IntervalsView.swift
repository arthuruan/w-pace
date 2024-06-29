//
//  Intervals.swift
//  WPace
//
//  Created by Arthur Ruan on 29/06/24.
//

import SwiftUI

struct IntervalsView: View {
    @Binding var warmup: Workout?
    @Binding var blocks: [WorkoutBlock]
    @Binding var cooldwon: Workout?
    
    var body: some View {
        if (warmup != nil) {
            VStack(alignment: .leading) {
                Text("Warmup").bold()
                Text("for 5 min").font(.caption)
            }
        }
        ForEach(blocks, id: \.self) { block in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Block 1").bold()
                    }
                    VStack(alignment: .leading) {
                        ForEach(block.workouts, id: \.self) { workout in
                            Text("\(workout.type.rawValue), for 5 min").font(.caption)
                        }
                    }
                }
                Spacer()
                Text("x\(block.repetition)")
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
                Text("for 5 min").font(.caption)
            }
        }
    }
}

