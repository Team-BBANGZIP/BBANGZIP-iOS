//
//  TodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

protocol TodoRepository: Sendable {
    func fetchTimerTodos() async throws -> [Category]
    
    func updateTodoCompletion(
        todoId: Int,
        isCompleted: Bool
    ) async throws
    
    func addTodo(
        categoryIndex: Int,
        content: String
    ) async throws
}
