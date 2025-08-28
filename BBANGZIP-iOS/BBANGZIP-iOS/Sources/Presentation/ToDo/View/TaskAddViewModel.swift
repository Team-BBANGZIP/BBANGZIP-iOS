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
    @Published var startTime: Date? = nil
    private let onAddTask: (String, Date?) -> Void

    init(onAddTask: @escaping (String, Date?) -> Void) {
        self.onAddTask = onAddTask
    }

    func submitTask() {        
        let trimmed = newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        onAddTask(trimmed, startTime)
        newTaskText = ""
        startTime = nil
    }
}
