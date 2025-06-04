//
//  TodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

protocol TodoRepository {
    func fetchTimerTodos() async throws -> [Category]
    func updateTodoCompletion(
        todoId: Int,
        isCompleted: Bool
    ) async throws
}
