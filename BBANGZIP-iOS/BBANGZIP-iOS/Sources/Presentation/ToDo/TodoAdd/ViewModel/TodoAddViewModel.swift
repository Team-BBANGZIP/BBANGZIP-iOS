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
    private let onAddTodo: (String, Date?) -> Void

    init(onAddTodo: @escaping (String, Date?) -> Void) {
        self.onAddTodo = onAddTodo
    }

    func addTodo() {
        let trimmed = newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        onAddTodo(trimmed, startTime)
        newTodoTitle = ""
        startTime = nil
    }
}
