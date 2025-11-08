//
//  Date+Appday.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/29/25.
//

import Foundation

extension Calendar {
    func appToday(from now: Date = Date()) -> Date {
        let hour = component(.hour, from: now)
        let base = hour < 5 ? date(byAdding: .day, value: -1, to: now)! : now
        return startOfDay(for: base)
    }
}

