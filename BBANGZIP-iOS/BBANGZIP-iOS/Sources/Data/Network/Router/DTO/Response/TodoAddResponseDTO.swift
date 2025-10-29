//
//  TodoAddResponseDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/27/25.
//

import Foundation

struct TodoAddResponseDTO: Decodable {
    let code: Int
    let data: TodoAddedDataDTO

    struct TodoAddedDataDTO: Decodable {
        let todoId: Int
        let content: String
        let targetDate: String
        let startTime: String?
        let isCompleted: Bool
        let categoryId: Int
        let categoryColor: String
    }
}

extension TodoAddResponseDTO.TodoAddedDataDTO {
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
