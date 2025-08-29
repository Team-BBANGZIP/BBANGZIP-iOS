//
//  TodoCalendarView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/29/25.
//

import SwiftUI

struct TodoCalendarView: View {
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil
        
    private let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        
        return cal
    }
    
    var body: some View {
        VStack(spacing: 16) {
            calendarHeaderView
            
            calendarBodyView
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .background(Color(.secondaryLight))
    }
    
    private var calendarHeaderView: some View {
        HStack(spacing: 20) {
            BbangText(
                monthYearFormatter(date: currentDate),
                font: .subtitle1,
                color: Color(.labelNeutral)
            )
            .padding(.leading, 20)
            
            Button(action: {}) {
                Image(.icChevronLeft)
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
            }
            
            Button(action: {}) {
                Image(.icChevronRight)
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(.icMenu)
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(.labelAlternative))
            }
            .padding(.trailing, 20)
        }
    }
    
    private var calendarBodyView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(daysOfWeek.indices, id: \.self) { index in
                let day = daysOfWeek[index]
                if let date = calculateDateForDay(day) {
                    CalendarCellView(
                        day: day,
                        date: date,
                        selectedDate: $selectedDate
                    )
                }
            }
        }
    }
    
    private func monthYearFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        
        return formatter.string(from: date)
    }
       
    private func generateDates() -> [Date] {
        var dates: [Date] = []
        
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: currentDate)
        components.weekday = 2
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let startOfWeek = calendar.date(from: components) else { return dates }
        
        for dayOffset in 0...6 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                dates.append(date)
            }
        }
        
        return dates
    }
        
    private func calculateDateForDay(_ day: String) -> Date? {
        guard let dayIndex = daysOfWeek.firstIndex(of: day) else { return nil }
        let startOfWeek = generateDates().first
        
        return calendar.date(byAdding: .day, value: dayIndex, to: startOfWeek ?? currentDate)
    }
}

struct CalendarCellView: View {
    let day: String
    let date: Date
    @Binding var selectedDate: Date?
    
    var body: some View {
        VStack(spacing: 8) {
            BbangText(
                day,
                font: .label4,
                color: isSelected ? Color(.labelNormal) : Color(.labelAlternative)
            )
            BbangText(
                "\(calendar.component(.day, from: date))",
                font: .label4,
                color: isSelected ? Color(.labelNormal) : Color(.labelAlternative)
            )
        }
        .padding(.vertical, 8)
        .frame(width: 40)
        .background(isSelected ? Color(.secondaryStrong) : Color.clear)
        .cornerRadius(10)
        .contentShape(Rectangle())
        .onTapGesture {
            if selectedDate != date {
                selectedDate = date
            }
        }
    }
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        return cal
    }
    
    private var isSelected: Bool {
        if selectedDate == nil {
            return isToday(date: date)
        } else {
            return isSameDay(selectedDate, date)
        }
    }
    
    private func isToday(date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func isSameDay(_ date1: Date?, _ date2: Date) -> Bool {
        guard let date1 = date1 else { return false }
        return calendar.isDate(date1, equalTo: date2, toGranularity: .day)
    }
}

#Preview {
    TodoCalendarView()
}
