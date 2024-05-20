//
//  TimePickerView.swift
//  WPace
//
//  Created by Arthur Ruan on 19/05/24.
//

import SwiftUI

public struct TimerPicker: View {
    var title: String
    var columnType: ColumnType
    @Binding var timeInterval: TimeInterval
    @State var isWheelActive: Bool = false
    
    init(timeInterval: Binding<TimeInterval>, title: String, columnType: ColumnType) {
        self._timeInterval = timeInterval
        self.title = title
        self.columnType = columnType
    }
    public var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(TimeInterval(timeInterval).convert())
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isWheelActive = !isWheelActive
            }
            if isWheelActive {
                SetView(second: $timeInterval, columnType: columnType)
            }
        }
    }
}

#Preview {
    TimerPicker(timeInterval: .constant(0), title: "Test", columnType: .hours)
}
