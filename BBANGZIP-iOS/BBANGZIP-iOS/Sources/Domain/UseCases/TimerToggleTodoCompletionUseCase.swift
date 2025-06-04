//
//  TimerToggleTodoCompletionUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

protocol ToggleTodoCompletionUseCase {
    func execute(todoId: Int, isCompleted: Bool)
}

final class TimerToggleTodoCompletionUseCase: ToggleTodoCompletionUseCase {
    private let todoRepository: TodoRepository
    
    init(todoRepository: TodoRepository) {
        self.todoRepository = todoRepository
    }
    
    func execute(todoId: Int, isCompleted: Bool) {
        Task {
            do {
                try await todoRepository.updateTodoCompletion(
                    todoId: todoId,
                    isCompleted: isCompleted
                )
            } catch {
                print("❗️완료 상태 변경 실패: \(error)")
            }
        }
    }
}
