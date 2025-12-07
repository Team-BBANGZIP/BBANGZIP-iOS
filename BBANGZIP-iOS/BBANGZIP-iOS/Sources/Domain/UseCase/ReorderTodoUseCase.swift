//
//  ReorderTodoUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/19/25.
//

import Foundation

protocol ReorderTodoUseCase: Sendable {
    func execute(
        id: Int,
        originCategoryId: Int,
        targetCategoryId: Int,
        targetCategoryColor: String,
        todoList: [Int]
    ) async throws -> Bool
}

final class DefaultReorderTodoUseCase: ReorderTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        id: Int,
        originCategoryId: Int,
        targetCategoryId: Int,
        targetCategoryColor: String,
        todoList: [Int]
    ) async throws -> Bool {
        return try await repository.reorderTodo(
            request: TodoReorderRequestDTO(
                todoId: id,
                originCategoryId: originCategoryId,
                targetCategoryId: targetCategoryId,
                targetCategoryColor: targetCategoryColor,
                todoList: todoList
            )
        )
    }
}
