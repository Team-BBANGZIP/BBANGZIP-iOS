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
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    private let onEditTodo: (String) async throws -> Void
    private let originalTodo: String
    
    init(
        onEditTodo: @escaping (String) async throws -> Void,
        originalTodo: String
    ) {
        self.onEditTodo = onEditTodo
        self.originalTodo = originalTodo
        self.newTodo = originalTodo
    }
    
    func editTodoTitle() async {
        let trimmed = newTodo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed != originalTodo else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await onEditTodo(trimmed)
        } catch {
            errorMessage = "수정에 실패했어요. 잠시 후 다시 시도해 주세요."
        }
        
        isLoading = false
    }
}
