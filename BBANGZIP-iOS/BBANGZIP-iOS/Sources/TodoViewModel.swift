//
//  TodoViewModel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/30/25.
//

import SwiftUI

@MainActor
final class TodoViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var dates: [Date] = []
    
    let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(identifier: "Asia/Seoul")!
        cal.firstWeekday = 2
        
        return cal
    }()
    
    init() {
        updateDates()
    }
    
    func monthYearFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        
        return formatter.string(from: date)
    }
    
    func updateDates() {
        var dates: [Date] = []
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: currentDate)
        components.weekday = 2
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let startOfWeek = calendar.date(from: components) else { return }
        
        for dayOffset in 0...6 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                dates.append(date)
            }
        }
        
        self.dates = dates
    }
    
    func calculateDateForDay(_ day: String) -> Date? {
        guard let dayIndex = daysOfWeek.firstIndex(of: day),
              !dates.isEmpty,
              dayIndex < dates.count else { return nil }
        
        return dates[dayIndex]
    }
    
    func moveWeek(by value: Int) {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: currentDate) {
            currentDate = newDate
            updateDates()
        }
    }
}
