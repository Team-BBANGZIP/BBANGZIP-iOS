//
//  TimerCheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//
import SwiftUI

@MainActor
final class TimerCheckedOffViewModel: ObservableObject {
    @Published private(set) var categories: [Category] = []
    @Published var isSheetPresented: Bool = false
    
    private let repository: TodoRepository
    private let toggleUseCase: ToggleTodoCompletionUseCase
    
    init(
        repository: TodoRepository,
        toggleUseCase: ToggleTodoCompletionUseCase
    ) {
        self.repository = repository
        self.toggleUseCase = toggleUseCase
    }
    
    /// 프리뷰/테스트용!!
    convenience init(previewCategories: [Category]) {
        self.init(
            repository: MockTodoRepository(),
            toggleUseCase: MockToggleUseCase()
        )
        self.categories = previewCategories
    }
    
    func fetchData() {
        let repository = self.repository
        Task {
            do {
                let fetchedCategories = try await repository.fetchTimerTodos()
                self.categories = fetchedCategories
            } catch {
                print("데이터 가져오기 실패: \(error)")
            }
        }
    }
    
    func toggleCompletion(
        for categoryId: Int,
        todoId: Int
    ) {
        guard let categoryIndex = categories.firstIndex(where: { $0.id == categoryId }),
              let todoIndex = categories[categoryIndex].todos.firstIndex(where: { $0.id == todoId }) else {
            return
        }
        
        let oldTodo = categories[categoryIndex].todos[todoIndex]
        let updatedTodo = oldTodo.toggledCompleted()
        
        var updatedTodos = categories[categoryIndex].todos
        updatedTodos[todoIndex] = updatedTodo
        
        let updatedCategory = Category(
            id: categories[categoryIndex].id,
            name: categories[categoryIndex].name,
            color: categories[categoryIndex].color,
            todos: updatedTodos
        )
        
        categories[categoryIndex] = updatedCategory
        
        let toggleUseCase = self.toggleUseCase
        
        Task {
            do {
                try await toggleUseCase.execute(
                    todoId: todoId,
                    isCompleted: updatedTodo.isCompleted
                )
            } catch {
                print("상태 업데이트 실패: \(error)")
            }
        }
    }
}
