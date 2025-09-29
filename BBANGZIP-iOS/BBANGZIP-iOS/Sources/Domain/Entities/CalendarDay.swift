//
//  CalendarDay.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/30/25.
//

import Foundation

struct CalendarDay: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
}
