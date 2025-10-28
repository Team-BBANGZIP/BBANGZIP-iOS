//
//  DatePickerViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/30/25.
//

import SwiftUI
import Combine

final class DatePickerViewModel: ObservableObject {
    @Published private(set) var currentMonth: Date
    @Published private(set) var days: [CalendarDay] = []

    private var calendar: Calendar = Calendar(identifier: .gregorian)
    private let locale = Locale(identifier: "ko_KR")
    private let initialSelectedDate: Date
    
    @Published private var startWeekOnSunday: Bool = UserDefaults.standard.bool(forKey: "startWeekOnSunday")
    private var cancellable: AnyCancellable?
    
    init(selectedDate: Date) {
        self.currentMonth = selectedDate
        self.initialSelectedDate = selectedDate
        configureCalendar()
        setupStartWeekObserver()
        rebuildDays()
    }
    
    var weekdays: [String] {
        startWeekOnSunday
        ? ["일","월","화","수","목","금","토"]
        : ["월","화","수","목","금","토","일"]
    }

    var headerTitle: String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: currentMonth)
    }
    
    func moveMonth(by delta: Int) -> Date {
        guard let newMonth = calendar.date(
            byAdding: .month,
            value: delta,
            to: currentMonth
        ) else {
            return currentMonth
        }
        currentMonth = newMonth
        rebuildDays()
        return firstDay(of: newMonth)
    }
    
    func tapped(day: CalendarDay) -> Date? {
        guard day.isCurrentMonth else { return nil }
        return day.date
    }
    
    func isSelected(_ day: CalendarDay, selectedDate: Date) -> Bool {
        return calendar.isDate(day.date, inSameDayAs: selectedDate)
    }
    
    func isToday(_ day: CalendarDay) -> Bool {
        let appToday = calendar.appToday()
        return calendar.isDate(day.date, inSameDayAs: appToday)
    }

    func isSaveDisabled(selectedDate: Date) -> Bool {
        return calendar.isDate(selectedDate, inSameDayAs: initialSelectedDate)
    }
    
    private static func adjustedDate(for date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.hour], from: date)
        if let hour = components.hour, hour < 5 {
            return calendar.date(byAdding: .day, value: -1, to: date) ?? date
        } else {
            return date
        }
    }
    
    private func configureCalendar() {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = locale
        cal.timeZone = TimeZone(identifier: "Asia/Seoul")!
        cal.firstWeekday = startWeekOnSunday ? 1 : 2 
        self.calendar = cal
    }
    
    private func setupStartWeekObserver() {
        cancellable = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                let newValue = UserDefaults.standard.bool(forKey: "startWeekOnSunday")
                if newValue != self.startWeekOnSunday {
                    self.startWeekOnSunday = newValue
                    self.configureCalendar()
                    self.rebuildDays()
                }
            }
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
        let weekdayOfStart = calendar.component(.weekday, from: startOfMonth)
        let leadingSpaces = (weekdayOfStart - calendar.firstWeekday + 7) % 7
        
        var result: [CalendarDay] = []

        // MARK: 앞달 꼬리
        if leadingSpaces > 0,
           let prevMonth = calendar.date(byAdding: .month, value: -1, to: startOfMonth),
           let prevRange = calendar.range(of: .day, in: .month, for: prevMonth)
        {
            let prevDays = prevRange.count
            for i in 0..<leadingSpaces {
                let dayNum = prevDays - leadingSpaces + 1 + i
                if let d = calendar.date(bySetting: .day, value: dayNum, of: prevMonth) {
                    result.append(.init(date: d, isCurrentMonth: false, dayNumber: dayNum))
                }
            }
        }

        // MARK: 현재 달
        for dayNum in 1...daysInMonth {
            if let d = calendar.date(bySetting: .day, value: dayNum, of: startOfMonth) {
                result.append(.init(date: d, isCurrentMonth: true, dayNumber: dayNum))
            }
        }

        // MARK: 뒷달 머리
        while result.count % 7 != 0 {
            guard
                let last = result.last?.date,
                let next = calendar.date(byAdding: .day, value: 1, to: last)
            else { break }
            let dayNum = calendar.component(.day, from: next)
            result.append(.init(date: next, isCurrentMonth: false, dayNumber: dayNum))
        }

        // MARK: 6행 채우기
        if result.count <= 35 {
            var last = result.last?.date
            for _ in 0..<(42 - result.count) {
                guard let base = last,
                      let next = calendar.date(byAdding: .day, value: 1, to: base)
                else { break }
                let dayNum = calendar.component(.day, from: next)
                result.append(.init(date: next, isCurrentMonth: false, dayNumber: dayNum))
                last = next
            }
        }

        return result
    }
}
