//
//  CalendarCellView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/30/25.
//

import SwiftUI

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
