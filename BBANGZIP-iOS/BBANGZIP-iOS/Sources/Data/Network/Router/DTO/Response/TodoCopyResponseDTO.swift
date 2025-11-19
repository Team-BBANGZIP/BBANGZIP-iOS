//
//  TodoCopyResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/19/25.
//

import Foundation

struct TodoCopyResponseDTO: Decodable {
    let code: Int
    let data: TodoCopyDataDTO
    
    struct TodoCopyDataDTO: Decodable {
        let todoId: Int
        let content: String
        let targetDate: String
        let startTime: String?
        let isCompleted: Bool
        let categoryId: Int
        let categoryColor: String
    }
}

extension TodoCopyResponseDTO.TodoCopyDataDTO {
    func toEntity() -> TimerTodo {
        let color = CategoryColor.fromAPI(categoryColor)
        return TimerTodo(
            id: todoId,
            content: content,
            isCompleted: isCompleted,
            startTime: startTime,
            colorType: color
        )
    }
}
