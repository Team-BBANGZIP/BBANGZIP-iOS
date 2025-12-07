//
//  TodoRepeatResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/11/25.
//

import Foundation

struct TodoRepeatResponseDTO: Decodable {
    let code: Int
    let data: TodoRepeatDTO
    
    struct TodoRepeatDTO: Decodable {
        let todoId: Int
        let content: String
        let targetDate: String
        let startTime: String?
        let isCompleted: Bool
    }
}

extension TodoRepeatResponseDTO.TodoRepeatDTO {
    func toEntity() -> TodoRepeat {
        return TodoRepeat(
            todoId: todoId,
            content: content,
            targetDate: targetDate,
            startTime: startTime,
            isCompleted: isCompleted
        )
    }
}
