//
//  AddTodoUseCase.swift
//  BBANGZIP
//
//  Created by 김송희 on 6/13/25.
//

import Foundation

protocol AddTodoUseCase {
    func execute(categoryIndex: Int, content: String, startTime: Date?) async throws
}

final class DefaultAddTodoUseCase: AddTodoUseCase {
    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
    }

    func execute(
        categoryIndex: Int,
        content: String,
        startTime: Date?
    ) async throws {
        try await repository.addTodo(
            categoryIndex: categoryIndex,
            content: content,
            startTime: startTime
        )
    }
}

