//
//  TodoFetchResponseDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/28/25.
//

import Foundation

struct TodoFetchResponseDTO: Decodable {
    let code: Int
    let data: DataDTO

    struct DataDTO: Decodable {
        let commitmentMessage: String?
        let todoSummary: SummaryDTO
        let categories: [CategoryDTO]
    }

    struct SummaryDTO: Decodable {
        let date: String
        let totalCount: Int
        let completedCount: Int
    }

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
}

extension TodoFetchResponseDTO.DataDTO {
    func toEntity() -> TodoData {
        TodoData(
            myPromiseMessage: commitmentMessage ?? "나만의 다짐을 적어보세요",
            summary: TodoSummary(
                date: todoSummary.date,
                totalCount: todoSummary.totalCount,
                completedCount: todoSummary.completedCount
            ),
            categories: categories.map { $0.toEntity() }
        )
    }
}

extension TodoFetchResponseDTO.CategoryDTO {
    func toEntity() -> Category {
        let color = CategoryColor(rawValue: categoryColor ?? "") ?? .Todored1
        return Category(
            id: categoryId,
            name: categoryName,
            colorType: color,
            todos: todos.map { $0.toEntity(color: color) },
            isStopped: false
        )
    }
}

extension TodoFetchResponseDTO.TodoDTO {
    func toEntity(color: CategoryColor) -> TimerTodo {
        TimerTodo(
            id: todoId,
            content: content,
            isCompleted: isCompleted,
            startTime: startTime,
            colorType: color
        )
    }
}
