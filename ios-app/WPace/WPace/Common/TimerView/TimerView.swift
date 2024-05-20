//
//  TimePicker.swift
//  WPace
//
//  Created by Arthur Ruan on 18/05/24.
//

import SwiftUI


struct TimerView: View {
    @StateObject var viewModel = TimerViewModel()

    var body: some View {
        HStack() {
            TimePickerView(title: "hours",
                range: viewModel.hoursRange,
                binding: $viewModel.selectedHoursAmount)
            TimePickerView(title: "min",
                range: viewModel.minutesRange,
                binding: $viewModel.selectedMinutesAmount)
            TimePickerView(title: "sec",
                range: viewModel.secondsRange,
                binding: $viewModel.selectedSecondsAmount)
        }
        .padding(.all, 32)
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.black)
//        .foregroundColor(.white)
    }
}


struct TimePickerView: View {
    // This is used to tighten up the spacing between the Picker and its
    // respective label
    //
    // This allows us to avoid having to use custom
    private let pickerViewTitlePadding: CGFloat = 4.0

    let title: String
    let range: ClosedRange<Int>
    let binding: Binding<Int>

    var body: some View {
        HStack(spacing: -pickerViewTitlePadding) {
            Picker("a", selection: binding) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        // Forces the text in the Picker to be
                        // right-aligned
                        Spacer()
                        Text("\(timeIncrement)")
//                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .pickerStyle(InlinePickerStyle())
//            .labelsHidden()

            Text(title)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    TimerView()
}
