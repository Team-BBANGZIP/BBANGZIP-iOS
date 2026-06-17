//
//  TimerCheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import Foundation

@MainActor
final class TimerCheckedOffViewModel: ObservableObject {
    @Published private(set) var categories: [Category] = []
    @Published var isSheetPresented: Bool = false
    @Published var selectedCategoryIndex: Int?
    
    let addUseCase: AddTodoUseCase
    private let fetchUseCase: FetchTodosUseCase
    private let toggleUseCase: ToggleTodoCompletionUseCase
    private let editUseCase: EditTodoUseCase
    
    var selectedCategory: Category? {
        guard let index = selectedCategoryIndex,
              index < categories.count else { return nil }
        return categories[index]
    }
    
    var currentTargetDate: Date {
        Calendar.current.appToday()
    }
    
    init(
        fetchUseCase: FetchTodosUseCase,
        toggleUseCase: ToggleTodoCompletionUseCase,
        addUseCase: AddTodoUseCase,
        editUseCase: EditTodoUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.toggleUseCase = toggleUseCase
        self.addUseCase = addUseCase
        self.editUseCase = editUseCase
    }
    
    func fetchData() {
        Task {
            do {
                let data = try await fetchUseCase.execute(date: currentTargetDate)
                self.categories = data.categories
            } catch {
                print("❌ 데이터 가져오기 실패: \(error)")
            }
        }
    }
    
    func makeTodoViewModel(todo: TimerTodo) -> TimerTodoViewModel {
        TimerTodoViewModel(
            todo: todo,
            toggleUseCase: toggleUseCase,
            onUpdate: { [weak self] updatedTodo in
                self?.updateTodoCompletion(updatedTodo)
            }
        )
    }
    
    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) {
        let localAddUseCase = addUseCase
        Task {
            do {
                _ = try await localAddUseCase.execute(
                    categoryId: categoryId,
                    content: content,
                    targetDate: targetDate,
                    startTime: startTime
                )
                fetchData()
            } catch {
                print("❌ 할 일 추가 실패: \(error)")
            }
        }
    }
    
    func updateTodoCompletion(_ updatedTodo: TimerTodo) {
        if let cIndex = categories.firstIndex(where: { $0.todos.contains(where: { $0.id == updatedTodo.id }) }),
           let tIndex = categories[cIndex].todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            categories[cIndex].todos[tIndex] = updatedTodo
        }
    }
    
    func updateTodoContent(todoId: Int, newContent: String) async throws {
        try await editUseCase.execute(id: todoId, content: newContent)
        fetchData()
    }
}
