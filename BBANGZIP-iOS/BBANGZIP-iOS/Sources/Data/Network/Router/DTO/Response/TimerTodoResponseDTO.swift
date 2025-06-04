//
//  TimerTodoResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import SwiftUI

struct CategoryDTO: Decodable {
    let categoryId: Int
    let categoryName: String
    let categoryColor: String?
    let todos: [TodoDTO]
}

struct TodoDTO: Decodable {
    let todoId: Int
    let content: String
    let isCompleted: Bool
    let startTime: String?
}

extension CategoryDTO {
    func toEntity() -> Category {
        let mappedColor = Color(categoryColor ?? "gray")
        
        return Category(
            id: categoryId,
            name: categoryName,
            color: mappedColor,
            todos: todos.map { $0.toEntity(with: mappedColor) }
        )
    }
}

extension TodoDTO {
    func toEntity(with color: Color) -> TimerTodo {
        return TimerTodo(
            id: todoId,
            content: content,
            isCompleted: isCompleted,
            startTime: startTime,
            color: color
        )
    }
}
