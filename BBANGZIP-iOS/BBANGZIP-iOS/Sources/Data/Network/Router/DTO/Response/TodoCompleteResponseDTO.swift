//
//  TodoCompleteResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/7/25.
//

import Foundation

struct TodoCompleteResponseDTO: Decodable {
    let code: Int
    let data: TodoCompleteDTO
    
    struct TodoCompleteDTO: Decodable {
        let todoId: Int
        let isCompleted: Bool
        let completedCount: Int
        let totalCount: Int
    }
}

extension TodoCompleteResponseDTO.TodoCompleteDTO {
    func toEntity() -> TodoComplete {
        return TodoComplete(
            todoId: todoId,
            isCompleted: isCompleted,
            completedCount: completedCount,
            totalCount: totalCount
        )
    }
}
