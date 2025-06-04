//
//  TimerCheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

class TimerCheckedOffViewModel: ObservableObject {
    @Published private(set) var categories: [Category]
    @Published var isSheetPresented: Bool = false
    
    private let toggleTodoCompletionUseCase: ToggleTodoCompletionUseCase
    
    init(
        categories: [Category],
        toggleTodoCompletionUseCase: TimerToggleTodoCompletionUseCase
    ) {
        self.categories = categories
        self.toggleTodoCompletionUseCase = toggleTodoCompletionUseCase
    }
    
    func toggleCompletion(
        for categoryId: Int,
        todoId: Int
    ) {
        guard let categoryIndex = categories.firstIndex(where: { $0.id == categoryId }) else { return }
        var category = categories[categoryIndex]
        
        guard let todoIndex = category.todos.firstIndex(where: { $0.id == todoId }) else { return }
        let todo = category.todos[todoIndex]
        let updatedTodo = todo.toggledCompleted()
        
        var updatedTodos = category.todos
        updatedTodos[todoIndex] = updatedTodo
        
        let updatedCategory = Category(
            id: category.id,
            name: category.name,
            color: category.color,
            todos: updatedTodos
        )
        
        categories[categoryIndex] = updatedCategory
        
        toggleTodoCompletionUseCase.execute(
            todoId: todoId,
            isCompleted: updatedTodo.isCompleted
        )
    }
}
