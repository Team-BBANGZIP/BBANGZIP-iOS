//
//  CheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

class CheckedOffViewModel: ObservableObject {
    @Published var categories: [Category]
    @Published var todosByCategory: [Int: [TodoItem]]
    @Published var isSheetPresented: Bool = false
    
    init(categories: [Category], todos: [Int: [TodoItem]]) {
        self.categories = categories
        self.todosByCategory = todos.mapValues { todoList in
            guard let categoryId = todoList.first?.id,
                  let color = categories.first(where: { $0.categoryId == categoryId })?.color else {
                return todoList
            }
            return todoList.map { todo in
                var updated = todo
                updated.color = color
                return updated
            }
        }
    }
    
    func toggleCompletion(for categoryId: Int, todoId: Int) {
        guard var todos = todosByCategory[categoryId],
              let index = todos.firstIndex(where: { $0.id == todoId }) else { return }
        
        todos[index].isCompleted.toggle()
        todosByCategory[categoryId] = todos
    }
}
