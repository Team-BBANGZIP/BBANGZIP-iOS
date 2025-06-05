//
//  MockToggleUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

struct MockToggleUseCase: ToggleTodoCompletionUseCase {
    private let logger = LoggerFactory.create(category: .domain)
    
    func execute(
        todoId: Int,
        isCompleted: Bool
    ) async throws {
        logger.debug("✅ MockToggleUseCase 실행됨: todoId=\(todoId), isCompleted=\(isCompleted)")
    }
}
