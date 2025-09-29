//
//  StartTimeViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/20/25.
//

import SwiftUI

@MainActor
final class StartTimeViewModel: ObservableObject {
    @Published var tempTime: Date
    
    init(selectedTime: Date?) {
        if let existingTime = selectedTime {
            self.tempTime = existingTime
        } else {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            components.hour = 12
            components.minute = 0
            self.tempTime = Calendar.current.date(from: components) ?? Date()
        }
    }
}
