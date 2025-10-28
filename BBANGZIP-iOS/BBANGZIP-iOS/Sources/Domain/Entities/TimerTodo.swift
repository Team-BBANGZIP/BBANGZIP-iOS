//
//  TimerTodo.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import Foundation

struct TimerTodo: Identifiable, Equatable, Hashable, Codable {
    let id: Int
    var content: String
    var isCompleted: Bool
    var startTime: String?
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
    
    func withUpdatedContent(_ content: String) -> TimerTodo {
        var c = self; c.content = content; return c
    }
    func withUpdatedStartTime(_ time: String?) -> TimerTodo {
        var c = self; c.startTime = time; return c
    }
}
