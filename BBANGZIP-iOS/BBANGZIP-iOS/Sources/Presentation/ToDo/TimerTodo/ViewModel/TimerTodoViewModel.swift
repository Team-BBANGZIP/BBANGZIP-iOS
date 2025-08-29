//
//  TimerTodoViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/9/25.
//

import Foundation

@MainActor
final class TimerTodoViewModel: ObservableObject, Identifiable {
    let id: Int
    @Published private(set) var todo: TimerTodo
    private let toggleUseCase: ToggleTodoCompletionUseCase
    
    init(
        todo: TimerTodo,
        toggleUseCase: ToggleTodoCompletionUseCase
    ) {
        self.id = todo.id
        self.todo = todo
        self.toggleUseCase = toggleUseCase
    }
    
    func toggleCompletion() {
        todo = todo.toggledCompleted()
        
        Task {
            do {
                try await toggleUseCase.execute(
                    todoId: todo.id,
                    isCompleted: todo.isCompleted
                )
                print("✅ 서버 상태 업데이트 성공: todoId=\(todo.id)")
            } catch {
                print("❌ 서버 상태 업데이트 실패: \(error)")
            }
        }
    }
}
