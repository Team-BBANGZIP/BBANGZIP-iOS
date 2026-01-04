//
//  TodoAddViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 6/12/25.
//

import SwiftUI

@MainActor
final class TodoAddViewModel: ObservableObject {
    @Published var newTodoTitle: String = ""
    @Published var startTime: Date? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let addTodoUseCase: AddTodoUseCase
    private let categoryId: Int
    private let targetDate: Date
    
    init(
        addTodoUseCase: AddTodoUseCase,
        categoryId: Int,
        targetDate: Date
    ) {
        self.addTodoUseCase = addTodoUseCase
        self.categoryId = categoryId
        self.targetDate = targetDate
    }
    
    func addTodo(onSuccess: (() -> Void)? = nil) {
        let trimmed = newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await addTodoUseCase.execute(
                    categoryId: categoryId,
                    content: trimmed,
                    targetDate: targetDate,
                    startTime: startTime
                )
                
                newTodoTitle = ""
                startTime = nil
                isLoading = false
                
                onSuccess?()
                
            } catch {
                LoggerFactory.create(category: .data)
                    .error("AddTodo Failed: \(error.localizedDescription)")
                errorMessage = "할 일 추가에 실패했습니다."
                isLoading = false
            }
        }
    }
}
