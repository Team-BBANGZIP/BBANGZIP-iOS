//
//  TimerTodoResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import Foundation

struct CategoryDTO: Decodable {
    let categoryId: Int
    let categoryName: String
    let categoryColor: String?
    let todos: [TodoDTO]
    let isStopped: Bool
}

struct TodoDTO: Decodable {
    let todoId: Int
    let content: String
    let isCompleted: Bool
    let startTime: String?
}

extension CategoryDTO {
    func toEntity() -> Category {
        let mappedColor = CategoryColor(rawValue: categoryColor ?? "Todored1") ?? .Todored1
        
        return Category(
            id: categoryId,
            name: categoryName,
            colorType: mappedColor,
            todos: todos.map { $0.toEntity(with: mappedColor) },
            isStopped: isStopped
        )
    }
}

extension TodoDTO {
    func toEntity(with colorType: CategoryColor) -> TimerTodo {
        return TimerTodo(
            id: todoId,
            content: content,
            isCompleted: isCompleted,
            startTime: startTime,
            colorType: colorType
        )
    }
}
