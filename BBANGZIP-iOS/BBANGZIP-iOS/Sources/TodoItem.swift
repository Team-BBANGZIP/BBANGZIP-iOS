//
//  TodoItem.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

import Foundation

public struct TodoItem: Identifiable {
    public let id: Int
    public var content: String
    public var isCompleted: Bool
    public var startTime: String?

    public init(todoId: Int, content: String, isCompleted: Bool, startTime: String?) {
        self.id = todoId
        self.content = content
        self.isCompleted = isCompleted
        self.startTime = startTime
    }
}

struct TodoCategory {
    public let categoryName: String
    public var todos: [TodoItem]
}
