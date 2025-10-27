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
    private let tokenManager: TokenManager

    init(repository: TodoRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
    }

    func execute(date: Date) async throws -> TodoData {
        guard let accessToken = tokenManager.getAccessToken() else {
            LoggerFactory.create(category: .data)
                .error("FetchTodos Error: AccessToken is nil")
            throw AuthError.invalidToken
        }
        return try await repository.fetchTodos(date: date, accessToken: accessToken)
    }
}
