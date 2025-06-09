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
}
