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

    init(onEditTodo: @escaping (String) -> Void) {
        self.onEditTodo = onEditTodo
    }

    func editTodoTitle() {
        let trimmed = newTodo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        onEditTodo(trimmed)
        newTodo = ""
    }
}
