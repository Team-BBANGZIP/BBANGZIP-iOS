//
//  TimerTodo.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import SwiftUI

struct TimerTodo: Identifiable, Equatable {
    let id: Int
    let content: String
    let isCompleted: Bool
    let startTime: String?
    let color: Color
    
    func toggledCompleted() -> TimerTodo {
        return TimerTodo(
            id: id,
            content: content,
            isCompleted: !isCompleted,
            startTime: startTime,
            color: color
        )
    }
    
    func withUpdatedCompletion(_ completed: Bool) -> TimerTodo {
        return TimerTodo(
            id: id,
            content: content,
            isCompleted: completed,
            startTime: startTime,
            color: color
        )
    }
}
