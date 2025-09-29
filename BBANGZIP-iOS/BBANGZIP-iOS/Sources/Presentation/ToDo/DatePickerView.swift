//
//  DatePickerView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/29/25.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @State private var currentMonth: Date
    @State private var pageSelection: Int = 1
    
    private let calendar = Calendar(identifier: .gregorian)
    
    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        _currentMonth = State(initialValue: selectedDate.wrappedValue)
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
                                moveMonth(by: 1)
                            } else if value.translation.width > 50 {
                                moveMonth(by: -1)
                            }
                        }
                )
            
            Button("저장하기") {
                // TODO: 저장하고 시트 닫기
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: calendar.isDateInToday(selectedDate) ? .disabled : .primary,
                    leftIcon: Image(.icCalendar)
                )
            )
            .disabled(calendar.isDateInToday(selectedDate))
            .padding(.horizontal, 47.5)
            .padding(.top, 40)
            .padding(.bottom, 20)
        }
    }
    
    private var monthHeader: some View {
        HStack() {
            Text(formattedYearMonth(currentMonth))
                .bbangFont(.subtitle1)
                .foregroundColor(Color(.labelNeutral))
                .frame(width: 74)
            
            Spacer()
                .frame(width: 16)
            
            HStack(spacing: 16) {
                Button(
                    action: {
                        moveMonth(by: -1)
                    }) {
                        Image(.icChevronLeft)
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.labelAlternative))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                
                Button(
                    action: {
                        moveMonth(by: 1)
                    }) {
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
            ForEach(weekdays, id: \.self) { w in
                Text(w)
                    .frame(maxWidth: .infinity)
                    .bbangFont(.label4)
                    .foregroundColor(Color(.labelAssistive))
            }
        }
    }
    
    private var monthGrid: some View {
        let days = makeMonthDays(for: currentMonth)
        let columns = Array(
            repeating: GridItem(.flexible(),  spacing: 0),
            count: 7
        )
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(days) { day in
                DayCell(
                    day: day,
                    isSelected: calendar.isDate(day.date, inSameDayAs: selectedDate),
                    isToday: calendar.isDateInToday(day.date)
                )
                .onTapGesture {
                    guard day.isCurrentMonth else { return }
                    selectedDate = day.date
                }
            }
        }
    }
    
    private func formattedYearMonth(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyy년 M월"
        return f.string(from: date)
    }
    
    private func firstDay(of date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }
    
    private func moveMonth(by delta: Int) {
        if let newMonth = calendar.date(
            byAdding: .month,
            value: delta,
            to: currentMonth
        ) {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentMonth = newMonth
                selectedDate = firstDay(of: newMonth)
            }
        }
    }
}

private struct MonthDay: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
}

private struct DayCell: View {
    let day: MonthDay
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

private extension DatePickerView {
    func makeMonthDays(for anchor: Date) -> [MonthDay] {
        guard
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: anchor)),
            let range = calendar.range(of: .day, in: .month, for: startOfMonth)
        else { return [] }

        let daysInMonth = range.count
        
        let weekdayOfStart_sunBased = calendar.component(.weekday, from: startOfMonth)
        let leadingSpaces = (weekdayOfStart_sunBased + 5) % 7
        
        var result: [MonthDay] = []
        if leadingSpaces > 0,
           let prevMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth),
           let prevRange = calendar.range(of: .day, in: .month, for: prevMonth)
        {
            let prevDays = prevRange.count
            for i in 0..<leadingSpaces {
                let day = prevDays - leadingSpaces + 1 + i
                if let d = calendar.date(bySetting: .day, value: day, of: prevMonth) {
                    result.append(.init(date: d, isCurrentMonth: false))
                }
            }
        }
        
        for day in 1...daysInMonth {
            if let d = calendar.date(bySetting: .day, value: day, of: startOfMonth) {
                result.append(.init(date: d, isCurrentMonth: true))
            }
        }
        
        while result.count % 7 != 0 {
            guard
                let last = result.last?.date,
                let next = calendar.date(byAdding: .day, value: 1, to: last)
            else { break }
            result.append(.init(date: next, isCurrentMonth: false))
        }
        
        if result.count <= 35 {
            var last = result.last?.date
            for _ in 0..<(42 - result.count) {
                guard let base = last,
                      let next = calendar.date(byAdding: .day, value: 1, to: base)
                else { break }
                result.append(.init(date: next, isCurrentMonth: false))
                last = next
            }
        }
        
        return result
    }
}

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

