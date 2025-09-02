//
//  TodoViewModel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/30/25.
//

import SwiftUI

@MainActor
final class TodoViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var dates: [Date] = []
    @Published var todoData: TodoData?
    @Published var isSheetPresented: Bool = false
    @Published var selectedCategoryIndex: Int?
    
    let daysOfWeek = ["월", "화", "수", "목", "금", "토", "일"]
    
    private let calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(identifier: "Asia/Seoul")!
        cal.firstWeekday = 2
        
        return cal
    }()
    
    private let fetchUseCase: FetchTimerTodosUseCase
    private let toggleUseCase: ToggleTodoCompletionUseCase
    private let addUseCase: AddTodoUseCase
    
    init(
        fetchUseCase: FetchTimerTodosUseCase,
        toggleUseCase: ToggleTodoCompletionUseCase,
        addUseCase: AddTodoUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.toggleUseCase = toggleUseCase
        self.addUseCase = addUseCase
        
        updateDates()
    }
    
    func fetchData() {
        Task {
            do {
                self.todoData = try await fetchUseCase.execute()
            } catch {
                print("❌ 데이터 가져오기 실패: \(error)")
            }
        }
    }

    func moveFlatItems(from source: IndexSet, to destination: Int) {
        guard todoData?.categories != nil else { return }

        var items = todoItems

        let movingTodos = source.compactMap { idx -> TimerTodo? in
            if case .todo(let t) = items[idx] { return t }
            return nil
        }
        if movingTodos.isEmpty { return }

        items.remove(atOffsets: source)

        let adjusted = max(0, min(destination - source.filter { $0 < destination }.count, items.count))

        func indexOfCategoryHeader(_ ci: Int) -> Int? {
            items.firstIndex {
                if case .category(_, let idx) = $0 { return idx == ci }
                return false
            }
        }
        
        func indexAfterHeader(_ ci: Int) -> Int? {
            guard let header = indexOfCategoryHeader(ci) else { return nil }
            return min(header + 1, items.count)
        }
        
        func indexOfTailDropZone(_ ci: Int) -> Int? {
            items.firstIndex {
                if case .tailDropZone(let idx) = $0 { return idx == ci }
                return false
            }
        }

        // 삽입 위치 계산
        var insertIndex = adjusted
        if adjusted < items.count {
            switch items[adjusted] {
            case .headDropZone(let ci):
                if let head = indexAfterHeader(ci) { insertIndex = head }
            case .tailDropZone(let ci):
                if let tail = indexOfTailDropZone(ci) { insertIndex = tail }
            case .globalTail:
                insertIndex = items.count
            case .category, .todo:
                break
            }
        } else {
            insertIndex = items.count
        }

        // 삽입
        for (offset, todo) in movingTodos.enumerated() {
            items.insert(.todo(todo), at: insertIndex + offset)
        }

        var newCategories: [Category] = []
        var currentCat: Category?

        for item in items {
            switch item {
            case .category(let cat, _):
                if let existing = currentCat { newCategories.append(existing) }
                currentCat = Category(id: cat.id, name: cat.name, colorType: cat.colorType, todos: [])
            case .todo(let todo):
                currentCat?.todos.append(todo)
            case .headDropZone, .tailDropZone, .globalTail:
                break
            }
        }
        if let last = currentCat { newCategories.append(last) }

        todoData?.categories = newCategories
        objectWillChange.send()
    }
    
    func makeTodoViewModel(todo: TimerTodo) -> TimerTodoViewModel {
        TimerTodoViewModel(
            todo: todo,
            toggleUseCase: toggleUseCase
        )
    }
    
    func addTodo(content: String) {
        guard let index = selectedCategoryIndex else { return }

        let localAddUseCase = addUseCase
        Task {
            do {
                try await localAddUseCase.execute(
                    categoryIndex: index,
                    content: content
                )
                fetchData()
            } catch {
                print("❌ 할 일 추가 실패: \(error)")
            }
        }
    }
    
    func monthYearFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        
        return formatter.string(from: date)
    }
    
    func updateDates() {
        var dates: [Date] = []
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: currentDate)
        components.weekday = 2
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let startOfWeek = calendar.date(from: components) else { return }
        
        for dayOffset in 0...6 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                dates.append(date)
            }
        }
        
        self.dates = dates
    }
    
    func calculateDateForDay(_ day: String) -> Date? {
        guard let dayIndex = daysOfWeek.firstIndex(of: day),
              !dates.isEmpty,
              dayIndex < dates.count else { return nil }
        
        return dates[dayIndex]
    }
    
    func moveWeek(by value: Int) {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: currentDate) {
            currentDate = newDate
            updateDates()
        }
    }
}

extension TodoViewModel {
    var todoItems: [TodoItem] {
        guard let categories = todoData?.categories else { return [] }
        var result: [TodoItem] = []
        for (idx, cat) in categories.enumerated() {
            result.append(.category(cat, index: idx))
            result.append(.headDropZone(categoryIndex: idx))
            
            for todo in cat.todos {
                result.append(.todo(todo))
            }
            
            result.append(.tailDropZone(categoryIndex: idx))
        }
        result.append(.globalTail)
        return result
    }
}
