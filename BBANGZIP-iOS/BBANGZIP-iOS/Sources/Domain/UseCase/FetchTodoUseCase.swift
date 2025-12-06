//
//  FetchTodoUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/9/25.
//

import Foundation

protocol FetchTodosUseCase: Sendable {
    func execute(date: Date) async throws -> TodoData
}

final class DefaultFetchTodosUseCase: FetchTodosUseCase {
    private let repository: TodoRepository

    init(repository: TodoRepository) {
        self.repository = repository
    }

    func execute(date: Date) async throws -> TodoData {
        return try await repository.fetchTodos(date: date)
    }
}
