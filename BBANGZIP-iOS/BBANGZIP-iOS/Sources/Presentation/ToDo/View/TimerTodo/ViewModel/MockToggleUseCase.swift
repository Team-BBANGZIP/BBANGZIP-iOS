//
//  MockToggleUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

struct MockToggleUseCase: ToggleTodoCompletionUseCase {
    func execute(
        todoId: Int,
        isCompleted: Bool
    ) async throws {
        print("✅ MockToggleUseCase executed: todoId=\(todoId), completed=\(isCompleted)")
    }
}

