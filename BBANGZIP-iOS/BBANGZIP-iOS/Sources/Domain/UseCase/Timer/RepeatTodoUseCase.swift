//
//  RepeatTodoUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/11/25.
//

import Foundation

protocol RepeatTodoUseCase: Sendable {
    func execute(
        todoId: Int,
        targetDate: Date
    ) async throws -> TodoRepeat
}

final class DefaultRepeatTodoUseCase: RepeatTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        todoId: Int,
        targetDate: Date
    ) async throws -> TodoRepeat {
        return try await repository.repeatTodo(
            id: todoId,
            targetDate: targetDate
        )
    }
}
