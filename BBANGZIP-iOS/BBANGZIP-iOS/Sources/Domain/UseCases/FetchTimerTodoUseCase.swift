//
//  FetchTimerTodoUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/9/25.
//

import Foundation

protocol FetchTimerTodosUseCase: Sendable {
    func execute() async throws -> [Category]
}

final class DefaultFetchTimerTodosUseCase: FetchTimerTodosUseCase {
    private let todoRepository: TodoRepository
    
    init(repository: TodoRepository) {
        self.todoRepository = repository
    }
    
    func execute() async throws -> [Category] {
        try await todoRepository.fetchTimerTodos()
    }
}
