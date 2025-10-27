//
//  AddTodoUseCase.swift
//  BBANGZIP
//
//  Created by 김송희 on 6/13/25.
//

import Foundation

protocol AddTodoUseCase: Sendable {
    func execute(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo
}

final class DefaultAddTodoUseCase: AddTodoUseCase {
    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
        print("🧩 AddTodoUseCase repository type =", type(of: repository))
    }

    func execute(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo {
        print("🧭 execute() using repo:", type(of: repository))
        
        return try await repository.addTodo(
            categoryId: categoryId,
            content: content,
            targetDate: targetDate,
            startTime: startTime
        )
    }
}

