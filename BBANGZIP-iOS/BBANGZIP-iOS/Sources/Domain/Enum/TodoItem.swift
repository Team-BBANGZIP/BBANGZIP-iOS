//
//  TodoItem.swift
//  BBANGZIP
//
//  Created by 최유빈 on 9/3/25.
//

import Foundation

enum TodoItem: Identifiable, Equatable {
    case category(Category, index: Int)
    case todo(TimerTodo)
    case headDropZone(categoryIndex: Int)
    case tailDropZone(categoryIndex: Int)
    case globalTail

    var id: Int {
        switch self {
        case .category(_, let index):
            return -(index + 1)
        case .todo(let todo):
            return todo.id
        case .headDropZone(let ci):
            return -(30_000 + ci)
        case .tailDropZone(let ci):
            return -(40_000 + ci)
        case .globalTail:
            return -999_999
        }
    }

    var stableID: String {
        switch self {
        case .category(_, let idx):
            return "cat-\(idx)"
        case .todo(let t):
            return "todo-\(t.id)"
        case .headDropZone(let ci):
            return "drop-head-\(ci)"
        case .tailDropZone(let ci):
            return "drop-tail-\(ci)"
        case .globalTail:
            return "drop-global"
        }
    }

    var asCategory: (Category, index: Int)? {
        if case .category(let c, let i) = self { return (c, i) }
        return nil
    }
    var asTodo: TimerTodo? {
        if case .todo(let t) = self { return t }
        return nil
    }
}
