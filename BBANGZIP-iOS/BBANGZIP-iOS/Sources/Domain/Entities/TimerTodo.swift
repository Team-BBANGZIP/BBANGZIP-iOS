//
//  TimerTodo.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import Foundation

struct TimerTodo: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    let content: String
    var isCompleted: Bool
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

extension TimerTodo {
    func withUpdatedColorType(_ colorType: CategoryColor) -> TimerTodo {
        TimerTodo(
            id: id,
            content: content,
            isCompleted: isCompleted,
            startTime: startTime,
            colorType: colorType
        )
    }
}
