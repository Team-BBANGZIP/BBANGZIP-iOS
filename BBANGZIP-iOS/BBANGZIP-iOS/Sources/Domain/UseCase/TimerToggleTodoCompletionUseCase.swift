//
//  TimerToggleTodoCompletionUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

protocol ToggleTodoCompletionUseCase: Sendable {
    func execute(
        todoId: Int,
        isCompleted: Bool
    ) async throws -> TodoComplete
}

final class TimerToggleTodoCompletionUseCase: ToggleTodoCompletionUseCase {
    private let todoRepository: TodoRepository

    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }

    func execute(
        todoId: Int,
        isCompleted: Bool
    ) async throws -> TodoComplete {
        try await todoRepository.completeTodo(
            todoId: todoId,
            isCompleted: isCompleted
        )
    }
}
