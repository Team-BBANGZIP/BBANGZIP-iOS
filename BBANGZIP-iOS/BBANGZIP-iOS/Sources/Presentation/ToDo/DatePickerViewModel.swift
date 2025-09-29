//
//  DatePickerViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/30/25.
//

import Foundation

final class DatePickerViewModel: ObservableObject {
    @Published private(set) var currentMonth: Date
    @Published private(set) var days: [CalendarDay] = []
    
    private let calendar = Calendar(identifier: .gregorian)
    private let locale = Locale(identifier: "ko_KR")
    
    init(selectedDate: Date) {
        self.currentMonth = selectedDate
        rebuildDays()
    }
    
    var headerTitle: String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: currentMonth)
    }

    func moveMonth(by delta: Int) -> Date {
        let newMonth = calendar.date(
            byAdding: .month,
            value: delta,
            to: currentMonth
        ) ?? currentMonth
        currentMonth = newMonth
        rebuildDays()
        return firstDay(of: newMonth)
    }
    
    func tapped(day: CalendarDay) -> Date? {
        guard day.isCurrentMonth else { return nil }
        return day.date
    }
    
    func isSelected(_ day: CalendarDay, selectedDate: Date) -> Bool {
        calendar.isDate(day.date, inSameDayAs: selectedDate)
    }
    
    func isToday(_ day: CalendarDay) -> Bool {
        calendar.isDateInToday(day.date)
    }
    
    func isSaveDisabled(selectedDate: Date) -> Bool {
        calendar.isDateInToday(selectedDate)
    }
    
    private func rebuildDays() {
        days = makeMonthDays(for: currentMonth)
    }
    
    private func firstDay(of date: Date) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }
    
    private func makeMonthDays(for anchor: Date) -> [CalendarDay] {
        guard
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: anchor)),
            let range = calendar.range(of: .day, in: .month, for: startOfMonth)
        else { return [] }

        let daysInMonth = range.count
        
        let weekdayOfStart_sunBased = calendar.component(.weekday, from: startOfMonth)
        let leadingSpaces = (weekdayOfStart_sunBased + 5) % 7
        
        var result: [CalendarDay] = []
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
