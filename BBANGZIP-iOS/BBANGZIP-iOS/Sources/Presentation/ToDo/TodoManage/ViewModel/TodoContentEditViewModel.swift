//
//  TodoContentEditViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/28/25.
//

import Foundation
import SwiftUI

@MainActor
final class TodoContentEditViewModel: ObservableObject {
    @Published var newTodo: String = ""
    private let onEditTodo: (String) -> Void
    private let originalTodo: String

    init(
        onEditTodo: @escaping (String) -> Void,
        originalTodo: String
    ) {
        self.onEditTodo = onEditTodo
        self.originalTodo = originalTodo
        self.newTodo = originalTodo
    }

    func editTodoTitle() {
        let trimmed = newTodo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard trimmed != originalTodo else { return }

        onEditTodo(trimmed)
    }
}
