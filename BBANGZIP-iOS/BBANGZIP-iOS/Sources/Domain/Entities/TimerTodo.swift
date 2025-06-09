//
//  TimerTodo.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import Foundation

struct TimerTodo: Identifiable, Equatable {
    let id: Int
    let content: String
    let isCompleted: Bool
    let startTime: String?
    let colorType: CategoryColor
    
    func toggledCompleted() -> TimerTodo {
        TimerTodo(
            id: id,
            content: content,
            isCompleted: !isCompleted,
            startTime: startTime,
            colorType: colorType
        )
    }
    
    func withUpdatedCompletion(_ completed: Bool) -> TimerTodo {
        TimerTodo(
            id: id,
            content: content,
            isCompleted: completed,
            startTime: startTime,
            colorType: colorType
        )
    }
}
