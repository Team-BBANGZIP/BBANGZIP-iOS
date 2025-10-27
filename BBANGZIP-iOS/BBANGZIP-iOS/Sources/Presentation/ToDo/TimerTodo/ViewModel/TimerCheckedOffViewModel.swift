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
    private let fetchUseCase: FetchTimerTodosUseCase
    private let toggleUseCase: ToggleTodoCompletionUseCase
    
    var selectedCategory: Category? {
        guard let index = selectedCategoryIndex,
              index < categories.count else { return nil }
        return categories[index]
    }

    var currentTargetDate: Date {
        return Date()
    }
    
    init(
        fetchUseCase: FetchTimerTodosUseCase,
        toggleUseCase: ToggleTodoCompletionUseCase,
        addUseCase: AddTodoUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.toggleUseCase = toggleUseCase
        self.addUseCase = addUseCase
    }
    
    func fetchData() {
        Task {
            do {
                self.categories = try await fetchUseCase.execute().categories
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
}
