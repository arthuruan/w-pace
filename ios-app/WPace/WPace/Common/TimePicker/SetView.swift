//
//  SetView.swift
//  WPace
//
//  Created by Arthur Ruan on 19/05/24.
//

import SwiftUI

enum ColumnType {
    case hours
    case minutes
    case seconds
}

struct TimeIndexType {
    var hours: Int
    var minutes: Int
    var seconds: Int
}

struct SetView: UIViewRepresentable {
    @Binding var second: TimeInterval
    var columnType: ColumnType = .hours

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        var timeIndex: TimeIndexType = TimeIndexType(hours: 0, minutes: 0, seconds: 0)
        
        switch (self.columnType) {
        case .hours:
            timeIndex.hours = second.toHour()
            timeIndex.minutes = second.toMinute()
            timeIndex.seconds = second.toSecond()
            picker.selectRow(timeIndex.hours, inComponent: 0, animated: true)
            picker.selectRow(timeIndex.minutes, inComponent: 1, animated: true)
            picker.selectRow(timeIndex.seconds, inComponent: 2, animated: true)
            break
        case .minutes:
            timeIndex.minutes = second.toMinute()
            timeIndex.seconds = second.toSecond()
            picker.selectRow(timeIndex.minutes, inComponent: 0, animated: true)
            picker.selectRow(timeIndex.seconds, inComponent: 1, animated: true)
            break
        case .seconds:
            timeIndex.seconds = second.toSecond()
            picker.selectRow(timeIndex.seconds, inComponent: 0, animated: true)
            break
        }

        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var setView: SetView
        var dataList: [[String?]]

        init(_ view: SetView) {
            self.setView = view
            
            switch(self.setView.columnType) {
            case .hours:
                dataList = [[], [], []]
                for i in 0...23 {
                    dataList[0].append("\(i) h")
                }
                for i in 0...59 {
                    dataList[1].append("\(i) m")
                }
                for i in 0...59 {
                    dataList[2].append("\(i) s")
                }
                break
            case .minutes:
                dataList = [[], []]
                for i in 0...59 {
                    dataList[0].append("\(i) m")
                }
                for i in 0...59 {
                    dataList[1].append("\(i) s")
                }
                break
            case .seconds:
                dataList = [[]]
                for i in 0...59 {
                    dataList[0].append("\(i) s")
                }
                break
            }
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return dataList.count
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return dataList[component].count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return dataList[component][row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let h = TimeInterval(setView.second.toHour() * 3600)
            let m = TimeInterval(setView.second.toMinute() * 60)
            let s = TimeInterval(setView.second.toSecond())
            switch(self.setView.columnType) {
            case .hours:
                switch component {
                case 0:
                    setView.second = TimeInterval(row * 3600) + m + s
                case 1:
                    setView.second = TimeInterval(row * 60) + h + s
                case 2:
                    setView.second = TimeInterval(row) + h + m
                default: break
                }
                break
            case .minutes:
                switch component {
                case 0:
                    setView.second = TimeInterval(row * 60) + h + s
                case 1:
                    setView.second = TimeInterval(row) + h + m
                default: break
                }
                break
            case .seconds:
                switch component {
                case 0:
                    setView.second = TimeInterval(row) + h + m
                default: break
                }
                break
            }
        }
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = (view as? UILabel) ?? UILabel()
            label.text = self.dataList[component][row]
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: 18)
            return label
        }
    }
}

#Preview {
    SetView(second: .constant(0), columnType: .minutes)
}

