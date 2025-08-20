//
//  StartTimeView.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/20/25.
//

import SwiftUI

struct StartTimeView: View {
    @Binding var selectedTime: Date?
    @Binding var isSheetPresented: Bool
    
    @State private var tempTime: Date
    
    init(
        selectedTime: Binding<Date?>,
        isSheetPresented: Binding<Bool>
    ) {
        self._selectedTime = selectedTime
        self._isSheetPresented = isSheetPresented
        
        if let existingTime = selectedTime.wrappedValue {
            _tempTime = State(initialValue: existingTime)
        } else {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 12
            components.minute = 0
            let defaultTime = Calendar.current.date(from: components) ?? Date()
            _tempTime = State(initialValue: defaultTime)
        }
    }
    
    var body: some View {
        Text("시작 시간 설정")
            .bbangFont(.title3)
            .foregroundStyle(Color(.labelAlternative))
            .padding(.top, 25)
        
        timePicker
            .padding(.horizontal, 20)
            .padding(.top, 32)
        
        buttons
            .padding(.horizontal, 20)
            .padding(.top, 48)
    }
    
    var timePicker: some View {
        DatePicker(
            "",
            selection: $tempTime,
            displayedComponents: .hourAndMinute
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .scaleEffect(0.9)
    }
    
    var buttons: some View {
        HStack(spacing: 15) {
            Button("취소") {
                selectedTime = nil
                isSheetPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                    rightIcon: Image(.icQuit)
                )
            )
            
            Button("설정") {
                selectedTime = tempTime
                isSheetPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary,
                    rightIcon: Image(.icCheck)
                )
            )
        }
    }
}
