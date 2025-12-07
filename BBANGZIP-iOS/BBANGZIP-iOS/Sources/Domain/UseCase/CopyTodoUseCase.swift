//
//  CopyTodoUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/19/25.
//

import Foundation

protocol CopyTodoUseCase: Sendable {
    func execute(
        todoId: Int
    ) async throws -> TimerTodo
}

final class DefaultCopyTodoUseCase: CopyTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        todoId: Int
    ) async throws -> TimerTodo {
        return try await repository.copyTodo(
            id: todoId
        )
    }
}
