//
//  TimerCheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//
import SwiftUI

@MainActor
final class TimerCheckedOffViewModel: ObservableObject {
    @Published private(set) var categories: [Category] = []
    @Published var isSheetPresented: Bool = false
    
    private let TodoRepository: TodoRepository
    private let toggleUseCase: ToggleTodoCompletionUseCase
    private let logger = LoggerFactory.create(category: .presentation)
    
    init(
        repository: TodoRepository,
        toggleUseCase: ToggleTodoCompletionUseCase
    ) {
        self.TodoRepository = repository
        self.toggleUseCase = toggleUseCase
    }
    
    /// 프리뷰/테스트용
    convenience init(previewCategories: [Category]) {
        self.init(
            repository: MockTodoRepository(),
            toggleUseCase: MockToggleUseCase()
        )
        self.categories = previewCategories
    }
    
    func fetchData() {
        let repository = self.TodoRepository
        
        logger.debug("fetchData() 호출됨")
        
        Task {
            do {
                let fetchedCategories = try await repository.fetchTimerTodos()
                self.categories = fetchedCategories
                logger.info("fetchData 성공: \(fetchedCategories.count, privacy: .public)개의 카테고리 로드됨")
            } catch {
                logger.error("❌ fetchData 실패: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
    
    func toggleCompletion(
        for categoryId: Int,
        todoId: Int
    ) {
        logger.debug("toggleCompletion 시작: categoryId=\(categoryId), todoId=\(todoId)")
        
        guard let categoryIndex = categories.firstIndex(where: { $0.id == categoryId }),
              let todoIndex = categories[categoryIndex].todos.firstIndex(where: { $0.id == todoId }) else {
            logger.warning("⚠️ toggleCompletion 실패: 인덱스 찾기 실패")
            return
        }
        
        let oldTodo = categories[categoryIndex].todos[todoIndex]
        let updatedTodo = oldTodo.toggledCompleted()
        
        var updatedTodos = categories[categoryIndex].todos
        updatedTodos[todoIndex] = updatedTodo
        
        let currentCategory = categories[categoryIndex]
        let updatedCategory = Category(
            id: currentCategory.id,
            name: currentCategory.name,
            colorType: currentCategory.colorType,
            todos: updatedTodos
        )
        
        categories[categoryIndex] = updatedCategory
        logger.info("로컬 상태 업데이트 완료: todoId=\(todoId), isCompleted=\(updatedTodo.isCompleted)")
        
        let toggleUseCase = self.toggleUseCase
        
        Task {
            do {
                try await toggleUseCase.execute(
                    todoId: todoId,
                    isCompleted: updatedTodo.isCompleted
                )
                logger.info("서버 상태 업데이트 성공: todoId=\(todoId)")
            } catch {
                logger.error("❌ 서버 상태 업데이트 실패: \(error.localizedDescription, privacy: .public)")
            }
        }
    }
    
}

extension CategoryColor {
    var color: Color {
        switch self {
        case .Todored1:
            return Color(.todored1)
        case .Todoyellow1:
            return Color(.todoyellow1)
        case .Todogreen1:
            return Color(.todogreen1)
        case .Todoblue1:
            return Color(.todoblue1)
        case .Todopurple1:
            return Color(.todopurple1)
        case .Todored2:
            return Color(.todored2)
        case .Todoyellow2:
            return Color(.todoyellow2)
        case .Todogreen2:
            return Color(.todogreen2)
        case .Todoblue2:
            return Color(.todoblue2)
        case .Todopurple2:
            return Color(.todopurple2)
        }
    }
}
