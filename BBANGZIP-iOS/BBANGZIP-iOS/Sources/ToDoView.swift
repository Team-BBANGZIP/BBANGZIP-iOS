//
//  ToDoView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/27/25.
//

import SwiftUI

struct ToDoView: View {
    @StateObject private var todoViewModel = TodoViewModel()
    @State private var selectedDate: Date? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            messageView
            
            VStack(spacing: 16) {
                calendarHeaderView
                
                calendarBodyView
                    .padding(.horizontal, 20)
            }
            .padding(.vertical, 12)
            .background(Color(.secondaryLight))
            
            Spacer()
        }
    }
    
    private var messageView: some View {
        ZStack {
            Color(.secondaryStrong)
            
            HStack(spacing: 0) {
                BbangText(
                    "나만의 다짐을 적어보세요",
                    font: .body4,
                    color: Color(.labelAlternative)
                )
                .padding(.leading, 20)
                
                Spacer()
                
                Image(.messageBread)
                    .padding(.top, 13)
                    .padding(.trailing, 19)
            }
        }
        .frame(height: 60)
    }
    
    private var calendarHeaderView: some View {
        HStack(spacing: 20) {
            BbangText(
                todoViewModel.monthYearFormatter(date: todoViewModel.currentDate),
                font: .subtitle1,
                color: Color(.labelNeutral)
            )
            .padding(.leading, 20)
            
            Button(action: { todoViewModel.moveMonth(by: -1) }) {
                Image(.icChevronLeft)
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
            }
            
            Button(action: { todoViewModel.moveMonth(by: 1) }) {
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
            ForEach(todoViewModel.daysOfWeek.indices, id: \.self) { index in
                let day = todoViewModel.daysOfWeek[index]
                if let date = todoViewModel.calculateDateForDay(day) {
                    CalendarCellView(
                        day: day,
                        date: date,
                        selectedDate: $selectedDate
                    )
                }
            }
        }
    }
}

#Preview {
    ToDoView()
}
