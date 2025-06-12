//
//  TaskAddViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 6/12/25.
//

import SwiftUI

@MainActor
final class TaskAddViewModel: ObservableObject {
    @Published var newTaskText: String = ""
    let onAddTask: (String) -> Void

    init(onAddTask: @escaping (String) -> Void) {
        self.onAddTask = onAddTask
    }

    func submitTask() {
        print("✅ submitTask() called with: \(newTaskText)")
        
        let trimmed = newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        onAddTask(trimmed)
        newTaskText = ""
    }
}
