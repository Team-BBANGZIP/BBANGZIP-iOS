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
    
    private let fetchUseCase: FetchTimerTodosUseCase
    private let toggleUseCase: ToggleTodoCompletionUseCase
    
    init(
        fetchUseCase: FetchTimerTodosUseCase,
        toggleUseCase: ToggleTodoCompletionUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.toggleUseCase = toggleUseCase
    }
    
    func fetchData() {
        Task {
            do {
                self.categories = try await fetchUseCase.execute()
            } catch {
                print("❌ 데이터 가져오기 실패: \(error)")
            }
        }
    }
    
    func makeTodoViewModel(todo: TimerTodo) -> TimerTodoViewModel {
        TimerTodoViewModel(
            todo: todo,
            toggleUseCase: toggleUseCase
        )
    }
    
    func addTodo(content: String) {
        let selectedIndex = selectedCategoryIndex ?? 0
        
        // TODO: 시간 설정
        let newTodo = TimerTodo(
            id: UUID().hashValue,
            content: content,
            isCompleted: false,
            startTime: "00:00",
            colorType: categories[selectedIndex].colorType
        )
        
        var updatedCategory = categories[selectedIndex]
        updatedCategory.todos.append(newTodo)
        categories[selectedIndex] = updatedCategory
    }
}
