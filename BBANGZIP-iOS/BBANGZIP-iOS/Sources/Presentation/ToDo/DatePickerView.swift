//
//  DatePickerView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/29/25.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @StateObject private var viewModel: DatePickerViewModel
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        _viewModel = StateObject(wrappedValue: DatePickerViewModel(selectedDate: selectedDate.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("날짜 바꾸기")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 25)
            
            monthHeader
                .padding(.top, 28)
                .padding(.horizontal, 20)
            
            weekdayHeader
                .padding(.top, 28)
                .padding(.horizontal, 25)
            
            monthGrid
                .padding(.top, 14)
                .padding(.horizontal, 20)
                .gesture(
                    DragGesture(minimumDistance: 30, coordinateSpace: .local)
                        .onEnded { value in
                            if value.translation.width < -50 {
                                selectedDate = viewModel.moveMonth(by: 1)
                            } else if value.translation.width > 50 {
                                selectedDate = viewModel.moveMonth(by: -1)
                            }
                        }
                )
            
            Button("저장하기") {
                // TODO: 저장하고 시트 닫기
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: viewModel.isSaveDisabled(selectedDate: selectedDate) ? .disabled : .primary,
                    leftIcon: Image(.icCalendar)
                )
            )
            .disabled(viewModel.isSaveDisabled(selectedDate: selectedDate))
            .padding(.horizontal, 47.5)
            .padding(.top, 40)
            .padding(.bottom, 20)
        }
    }
    
    private var monthHeader: some View {
        HStack {
            Text(viewModel.headerTitle)
                .bbangFont(.subtitle1)
                .foregroundColor(Color(.labelNeutral))
                .frame(width: 74)
            
            Spacer().frame(width: 16)
            
            HStack(spacing: 16) {
                Button {
                    selectedDate = viewModel.moveMonth(by: -1)
                } label: {
                    Image(.icChevronLeft)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(.labelAlternative))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button {
                    selectedDate = viewModel.moveMonth(by: 1)
                } label: {
                    Image(.icChevronRight)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(.labelAlternative))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
        }
    }
    
    private var weekdayHeader: some View {
        let weekdays = ["월","화","수","목","금","토","일"]
        return HStack {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .frame(maxWidth: .infinity)
                    .bbangFont(.label4)
                    .foregroundColor(Color(.labelAssistive))
            }
        }
    }
    
    private var monthGrid: some View {
        let columns = Array(
            repeating: GridItem(
                .flexible(),
                spacing: 0
            ),
            count: 7
        )
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(viewModel.days) { day in
                DayCell(
                    day: day,
                    isSelected: viewModel.isSelected(day, selectedDate: selectedDate),
                    isToday: viewModel.isToday(day)
                )
                .onTapGesture {
                    if let newDate = viewModel.tapped(day: day) {
                        selectedDate = newDate
                    }
                }
            }
        }
    }
}

private struct DayCell: View {
    let day: CalendarDay
    let isSelected: Bool
    let isToday: Bool
    
    private var textColor: Color {
        if !day.isCurrentMonth { return Color(.labelAssistive) }
        if isSelected { return .white }
        return Color(.labelAlternative)
    }
    
    var body: some View {
        VStack {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(Color(.labelAlternative))
                        .frame(width: 40, height: 40)
                } else if isToday && day.isCurrentMonth {
                    Circle()
                        .fill(Color(.backgroundAlternative))
                        .frame(width: 40, height: 40)
                }
                
                Text("\(Calendar.current.component(.day, from: day.date))")
                    .bbangFont(.label2)
                    .foregroundStyle(textColor)
            }
            .frame(width: 40, height: 40)
        }
    }
}

// MARK: - Preview
struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}

private struct PreviewWrapper: View {
    @State private var date = Calendar(identifier: .gregorian)
        .date(from: DateComponents(year: 2025, month: 9, day: 26))!
    
    var body: some View {
        DatePickerView(selectedDate: $date)
            .padding()
    }
}
