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
    var pickerType: PickerType
    var columnLabels: [String] = [" h", " m", " s"]
    @Binding var timeInterval: TimeInterval
    @State var isWheelActive: Bool = false
    
    init(timeInterval: Binding<TimeInterval>, title: String, pickerType: PickerType = .standard, columnType: ColumnType = .minutes) {
        self._timeInterval = timeInterval
        self.title = title
        self.columnType = columnType
        if pickerType == .pace {
            self.columnType = .minutes
            self.columnLabels = ["", "'", "\""]
        }
        self.pickerType = pickerType
    }
    public var body: some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(
                    pickerType == .pace ?
                        TimeInterval(timeInterval).convertPace() + " / km"
                    :
                        TimeInterval(timeInterval).convert()
                )
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isWheelActive = !isWheelActive
            }
            if isWheelActive {
                SetView(second: $timeInterval, columnType: columnType, columnLabels: self.columnLabels)
            }
        }
    }
}

#Preview {
    TimerPicker(timeInterval: .constant(0), title: "Test", columnType: .hours)
}
