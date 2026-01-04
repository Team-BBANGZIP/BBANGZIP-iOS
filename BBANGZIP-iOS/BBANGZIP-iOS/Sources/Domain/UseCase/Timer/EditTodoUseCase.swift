//
//  EditTodoUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 1/4/26.
//

import Foundation

protocol EditTodoUseCase: Sendable {
    func execute(
        id: Int,
        content: String
    ) async throws
}

final class DefaultEditTodoUseCase: EditTodoUseCase {
    private let repository: TodoRepository
    
    init(repository: TodoRepository) {
        self.repository = repository
    }
    
    func execute(
        id: Int,
        content: String
    ) async throws {
        try await repository.editTodo(
            id: id,
            content: content
        )
    }
}

