//
//  TodoManageViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/28/25.
//

import SwiftUI

@MainActor
final class TodoManageViewModel: ObservableObject {
    private let repository: TodoRepository
    private let todoId: Int
    private let repeatTodoUseCase: RepeatTodoUseCase
    private let copyTodoUseCase: CopyTodoUseCase
    
    private let titleBinding: Binding<String>
    private let startTimeBinding: Binding<String?>
    private let isAlertedBinding: Binding<Bool>
    
    @Published var title: String
    @Published var category: String
    @Published var startTimeString: String?
    @Published var isAlerted: Bool
    @Published var isCompleted: Bool
    @Published var changeDate: Date
    @Published var repeatDate: Date
    
    @Published var isEditSheetPresented: Bool = false
    @Published var isStartTimeSheetPresented: Bool = false
    @Published var isChangeDateSheetPresented: Bool = false
    @Published var isRepeatSheetPresented: Bool = false
    
    private let onDelete: () -> Void
    private let onPostpone: () -> Void
    private let onDuplicate: () -> Void
    private let onChangeDate: () -> Void
    private let onPatchedTitle: (String) -> Void
    private let onDeleted: (Int, Int, Int) -> Void
    private let onPatchedStartTime: (Int, String?) -> Void
    
    init(
        title: Binding<String>,
        category: String,
        startTime: Binding<String?>,
        isAlerted: Binding<Bool>,
        isCompleted: Bool,
        todoId: Int,
        repository: TodoRepository,
        repeatTodoUseCase: RepeatTodoUseCase,
        copyTodoUseCase: CopyTodoUseCase,
        initialTargetDate: Date?,
        onDelete: @escaping () -> Void,
        onPostpone: @escaping () -> Void,
        onDuplicate: @escaping () -> Void,
        onChangeDate: @escaping () -> Void,
        onPatchedTitle: @escaping (String) -> Void,
        onDeleted: @escaping (Int, Int, Int) -> Void,
        onPatchedStartTime: @escaping (Int, String?) -> Void
    ) {
        self.repository = repository
        self.repeatTodoUseCase = repeatTodoUseCase
        self.copyTodoUseCase = copyTodoUseCase
        self.todoId = todoId
        self.titleBinding = title
        self.startTimeBinding = startTime
        self.isAlertedBinding = isAlerted
        self.title = title.wrappedValue
        self.category = category
        self.startTimeString = startTime.wrappedValue
        self.isAlerted = isAlerted.wrappedValue
        self.isCompleted = isCompleted
        self.onDelete = onDelete
        self.onPostpone = onPostpone
        self.onDuplicate = onDuplicate
        self.onChangeDate = onChangeDate
        self.onPatchedTitle = onPatchedTitle
        self.onDeleted = onDeleted
        self.onPatchedStartTime = onPatchedStartTime
        let fallback = Calendar.current.appToday()
        self.changeDate = initialTargetDate ?? fallback
        self.repeatDate = initialTargetDate ?? fallback
    }
    
    var startTimeDate: Date? {
        get { startTimeString.flatMap { DateFormatter.inputTimeFormatter.date(from: $0) } }
        set {
            startTimeString = newValue.map { DateFormatter.inputTimeFormatter.string(from: $0) }
            startTimeBinding.wrappedValue = startTimeString
        }
    }
    
    var formattedStartTime: String {
        startTimeDate.map { DateFormatter.displayTimeFormatter.string(from: $0) } ?? "미설정"
    }
    
    func tapEdit() { isEditSheetPresented = true }
    func tapStartTime() { isStartTimeSheetPresented = true }
    
    func setTitle(_ newTitle: String) {
        title = newTitle
        titleBinding.wrappedValue = newTitle
    }
    
    func setAlerted(_ newValue: Bool) {
        isAlerted = newValue
        isAlertedBinding.wrappedValue = newValue
    }
    
    func patchTodoTitle(_ newTitle: String) async throws {
        guard newTitle != title else { return }
        let old = title

        do {
            try await repository.editTodo(id: todoId, content: newTitle)
            setTitle(newTitle)
            onPatchedTitle(newTitle)
            print("✅ Patch Todo Title successed: \(newTitle)")
        } catch {
            setTitle(old)
            print("❌ Patch Todo Title failed: \(error)")
            throw error
        }
    }
    
    func deleteTodo() async {
        do {
            let result = try await repository.deleteTodo(id: todoId)
            onDeleted(todoId, result.completedCount, result.totalCount)
            print("✅ Deleted Successed: \(todoId)")
        } catch {
            print("❌ Delete failed: \(error)")
        }
    }
    
    func patchStartTime(_ date: Date?) async {
        guard let date else { return }

        let old = startTimeString
        do {
            let newHHmm = try await repository.editTodoStartTime(id: todoId, startTime: date)
            startTimeDate = date
            onPatchedStartTime(todoId, newHHmm)
            print("✅ StartTime patch successed: \(date)")
        } catch {
            startTimeString = old
            startTimeBinding.wrappedValue = old
            print("❌ StartTime patch failed: \(error)")
        }
    }
    
    func rescheduleTodoToTomorrow() async {
        do {
            let newData = try await repository.rescheduleTodo(id: todoId, targetDate: nil)
            onDeleted(todoId, 0, 0)
            print("✅ Todo \(newData.todoId) moved to \(newData.targetDate)")
        } catch {
            print("❌ Reschedule to tomorrow failed: \(error)")
        }
    }

    func rescheduleTodo(to targetDate: Date) async {
        do {
            let newData = try await repository.rescheduleTodo(id: todoId, targetDate: targetDate)
            onDeleted(todoId, 0, 0)
            print("✅ Todo \(newData.todoId) moved to \(newData.targetDate)")
        } catch {
            print("❌ Reschedule failed: \(error)")
        }
    }
    
    func repeatTodo(at targetDate: Date) async {
        do {
            let result = try await repeatTodoUseCase.execute(
                todoId: todoId,
                targetDate: targetDate
            )
            print("✅ Todo \(result.todoId) repeat to \(result.targetDate)")
        } catch {
            print("❌ Repeat failed: \(error)")
        }
    }
    
    // TODO: 복제하기 기능 구현
    func copyTodo() async {
        do {
            let result = try await
            copyTodoUseCase.execute(todoId: todoId)
            onDuplicate()
            
            print("✅ Todo \(result.id) is copied")
        } catch {
            print("❌ Copy failed: \(error)")
        }
    }
}
