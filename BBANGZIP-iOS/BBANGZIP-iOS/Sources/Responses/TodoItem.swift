//
//  TodoItem.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

struct TodoItem: Identifiable {
    let id: Int
    var content: String
    var isCompleted: Bool
    var startTime: String?
    
    init(
        todoId: Int,
        content: String,
        isCompleted: Bool,
        startTime: String?
    ) {
        self.id = todoId
        self.content = content
        self.isCompleted = isCompleted
        self.startTime = startTime
    }
}

struct TodoCategory {
    let categoryName: String
    var todos: [TodoItem]
}
