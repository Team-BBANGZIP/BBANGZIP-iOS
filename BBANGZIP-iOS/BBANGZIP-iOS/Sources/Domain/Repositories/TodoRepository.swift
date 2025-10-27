//
//  TodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

protocol TodoRepository: Sendable {
    func fetchTimerTodos() async throws -> TodoData
    
    func updateTodoCompletion(
        todoId: Int,
        isCompleted: Bool
    ) async throws
    
    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo
    
    func updateCategory(_ category: Category) async throws
    func deleteCategory(id: Int) async throws
}

final class TodoRepositoryImpl: TodoRepository {
    private let api: API
    private let tokenManager = TokenManager.shared
    
    init(api: API = API()) {
        self.api = api
    }
    
    func fetchTimerTodos() async throws -> TodoData {
        // TODO: 구현
        throw RouterError.invalidURL
    }
    
    func updateTodoCompletion(todoId: Int, isCompleted: Bool) async throws {
        // TODO: 구현
    }
    
    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo {
        guard let accessToken = tokenManager.getAccessToken() else {
            LoggerFactory.create(category: .data)
                .error("AddTodo Error: AccessToken is nil")
            throw AuthError.invalidToken
        }
                
        let dto = TodoAddRequestDTO(
            categoryId: categoryId,
            content: content,
            targetDate: DateFormatter.inputDateYMDFormatter.string(from: targetDate),
            startTime: startTime.map { DateFormatter.inputTimeFormatter.string(from: $0) }
        )
                
        let router = BbangRouter.addTodo(dto: dto, accessToken: accessToken)
                
        do {
            let response: TodoAddResponseDTO = try await api.request(api: router)
            
            if response.code != 20100 {
                LoggerFactory.create(category: .data)
                    .error("AddTodo Error: Unexpected response code \(response.code)")
            }

            return response.data.toEntity()
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("AddTodo Request Failed: \(error.localizedDescription)")

            throw error
        }
    }
    
    func updateCategory(_ category: Category) async throws {}
    func deleteCategory(id: Int) async throws {}
}
