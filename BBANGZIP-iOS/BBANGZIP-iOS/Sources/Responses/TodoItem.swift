//
//  TodoItem.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

import SwiftUI

struct TodoItem: Identifiable {
    let id: Int
    var content: String
    var isCompleted: Bool
    var startTime: String?
    var color: Color
    
    init(
        todoId: Int,
        content: String,
        isCompleted: Bool,
        startTime: String?,
        color: Color = Color(.todored1)
    ) {
        self.id = todoId
        self.content = content
        self.isCompleted = isCompleted
        self.startTime = startTime
        self.color = color
    }
}

struct TodoCategory: Identifiable {
    let id = UUID()
    let categoryName: String
    var color: Color
    var todos: [TodoItem]
}
