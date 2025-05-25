//
//  CheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

class CheckedOffViewModel: ObservableObject {
    @Published var categories: [Category]
    @Published var isSheetPresented: Bool = false
    
    init(categories: [Category]) {
        self.categories = categories.map { category in
            let updatedTodos = category.todos.map { todo -> TodoItem in
                var mutableTodo = todo
                mutableTodo.color = category.color
                return mutableTodo
            }
            return Category(
                categoryId: category.categoryId,
                name: category.name,
                color: category.color,
                todos: updatedTodos
            )
        }
    }
}
