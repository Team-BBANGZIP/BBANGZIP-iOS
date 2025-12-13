//
//  TodoViewModel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/30/25.
//

import SwiftUI
import Combine

@MainActor
final class TodoViewModel: ObservableObject {
    @Published var currentDate: Date = Date()
    @Published var selectedDate: Date? = nil
    @Published var dates: [Date] = []
    @Published var todoData: TodoData?
    @Published var isAddTodoSheetPresented: Bool = false
    @Published var isMyPromiseSheetPresented: Bool = false
    @Published var selectedCategoryIndex: Int?
    
    @Published var isMeatballSheetPresented: Bool = false
    @Published var sheetTodoTitle: String = ""
    @Published var sheetTodoId: Int = 0
    @Published var sheetCategoryName: String = ""
    @Published var sheetStartTime: String? = ""
    @Published var sheetIsAlerted: Bool = false
    @Published var sheetIsCompleted: Bool = false
    
    @Published private var startWeekOnSunday: Bool = UserDefaults.standard.bool(forKey: "startWeekOnSunday")
    
    var daysOfWeek: [String] {
        startWeekOnSunday
        ? ["일", "월", "화", "수", "목", "금", "토"]
        : ["월", "화", "수", "목", "금", "토", "일"]
    }
    
    var currentTargetDate: Date {
        return selectedDate ?? currentDate
    }
    
    @Published private var calendar: Calendar = {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(identifier: "Asia/Seoul")!
        cal.firstWeekday = UserDefaults.standard.bool(forKey: "startWeekOnSunday") ? 1 : 2
        return cal
    }()
    
    
    private(set) var selectedTodoForMenu: TimerTodo? = nil
    
    private let fetchUseCase: FetchTodosUseCase
    private let toggleUseCase: ToggleTodoCompletionUseCase
    private let addUseCase: AddTodoUseCase
    private let writeCommitmentMessageUseCase: WriteCommitmentMessageUseCase
    private let reorderTodoUseCase: ReorderTodoUseCase
    
    var selectedCategoryId: Int? {
        guard let index = selectedCategoryIndex,
              let categories = todoData?.categories,
              index < categories.count else { return nil }
        return categories[index].id
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fetchUseCase: FetchTodosUseCase,
        toggleUseCase: ToggleTodoCompletionUseCase,
        addUseCase: AddTodoUseCase,
        writeCommitmentMessageUseCase: WriteCommitmentMessageUseCase,
        reorderTodoUseCase: ReorderTodoUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.toggleUseCase = toggleUseCase
        self.addUseCase = addUseCase
        self.writeCommitmentMessageUseCase = writeCommitmentMessageUseCase
        self.reorderTodoUseCase = reorderTodoUseCase
        self.currentDate = calendar.appToday()
        
        updateDates()
        setupStartWeekOnSundayObserver()
    }
    
    private func setupStartWeekOnSundayObserver() {
        NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let newValue = UserDefaults.standard.bool(forKey: "startWeekOnSunday")
                
                if newValue != self.startWeekOnSunday {
                    self.startWeekOnSunday = newValue
                    self.configureCalendar()
                    self.updateDates()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureCalendar() {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "ko_KR")
        cal.timeZone = TimeZone(identifier: "Asia/Seoul")!
        cal.firstWeekday = startWeekOnSunday ? 1 : 2
        self.calendar = cal
    }
    
    func fetchData() {
        Task {
            do {
                self.todoData = try await fetchUseCase.execute(date: currentTargetDate)
            } catch {
                print("❌ 데이터 가져오기 실패: \(error)")
            }
        }
    }
    
    func setSelectedDate(_ date: Date) {
        selectedDate = date
        fetchData()
    }
    
    func resetToToday() {
        let today = adjustedToday()
        currentDate = today
        selectedDate = nil
        updateDates()
        fetchData()
    }
    
    private func adjustedToday() -> Date {
        let now = Date()
        let hour = calendar.component(.hour, from: now)
        if hour < 5 {
            return calendar.date(byAdding: .day, value: -1, to: now) ?? now
        }
        return now
    }
    
    func moveTodoItems(from source: IndexSet, to destination: Int) {
        guard (todoData?.categories) != nil else { return }
        
        var items = todoItems
        
        let movingTodos: [TimerTodo] = source.compactMap { idx in
            if case .todo(let t) = items[idx] { return t }
            return nil
        }
        guard let movedTodo = movingTodos.first else { return }
        
        func findCategoryId(of todoId: Int, in items: [TodoItem]) -> Int? {
            guard let idx = items.firstIndex(where: {
                if case .todo(let t) = $0 { return t.id == todoId }
                return false
            }) else { return nil }
            
            for i in stride(from: idx - 1, through: 0, by: -1) {
                if case .category(let cat, _) = items[i] {
                    return cat.id
                }
            }
            return nil
        }
        
        guard let originCategoryId = findCategoryId(of: movedTodo.id, in: items) else { return }
        
        items.remove(atOffsets: source)
        
        let adjusted = max(
            0,
            min(destination - source.filter { $0 < destination }.count, items.count)
        )
        
        var insertIndex = adjusted
        func indexAfterHeader(_ ci: Int) -> Int? {
            items.firstIndex {
                if case .category(_, let idx) = $0 { return idx == ci }
                return false
            } .map { min($0 + 1, items.count) }
        }
        if adjusted < items.count {
            switch items[adjusted] {
            case .headDropZone(let ci):
                if let head = indexAfterHeader(ci) { insertIndex = head }
            case .tailDropZone(let ci):
                if let tail = items.firstIndex(where: {
                    if case .tailDropZone(let idx) = $0 { return idx == ci }
                    return false
                }) { insertIndex = tail }
            case .globalTail:
                insertIndex = items.count
            case .category, .todo:
                break
            }
        }
        
        func targetCategoryInfo(for insertIndex: Int, in items: [TodoItem]) -> (id: Int, color: CategoryColor)? {
            if items.indices.contains(insertIndex) {
                for i in stride(from: insertIndex, through: 0, by: -1) {
                    if case .category(let cat, _) = items[i] {
                        return (cat.id, cat.colorType)
                    }
                }
            }
            for i in insertIndex..<items.count {
                if case .category(let cat, _) = items[i] {
                    return (cat.id, cat.colorType)
                }
            }
            return nil
        }
        
        guard let target = targetCategoryInfo(for: insertIndex, in: items) else { return }
        
        for (offset, t) in movingTodos.enumerated() {
            let updated = t.withUpdatedColorType(target.color)
            items.insert(.todo(updated), at: insertIndex + offset)
        }
        
        var newCategories: [Category] = []
        var currentCat: Category?
        for item in items {
            switch item {
            case .category(let cat, _):
                if let exist = currentCat { newCategories.append(exist) }
                currentCat = Category(
                    id: cat.id,
                    name: cat.name,
                    colorType: cat.colorType,
                    todos: [],
                    isStopped: false
                )
            case .todo(let t):
                currentCat?.todos.append(t)
            case .headDropZone, .tailDropZone, .globalTail:
                break
            }
        }
        if let last = currentCat { newCategories.append(last) }
        todoData?.categories = newCategories
        objectWillChange.send()
        let targetCategoryTodos = newCategories.first { $0.id == target.id }?.todos.map { $0.id } ?? []
        
        let dto = TodoReorderRequestDTO(
            todoId: movedTodo.id,
            originCategoryId: originCategoryId,
            targetCategoryId: target.id,
            targetCategoryColor: target.color.apiValue,
            todoList: targetCategoryTodos
        )
        
        Task {
            do {
                _ = try await reorderTodoUseCase.execute(
                    id: dto.todoId,
                    originCategoryId: dto.originCategoryId,
                    targetCategoryId: dto.targetCategoryId,
                    targetCategoryColor: dto.targetCategoryColor,
                    todoList: dto.todoList
                )
                print("✅ Reorder Success:", dto)
            } catch {
                print("❌ Reorder Failed:", dto)
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
    
    func makeAddTodoViewModel() -> TodoAddViewModel? {
        guard let categoryId = selectedCategoryId else { return nil }
        return TodoAddViewModel(
            addTodoUseCase: addUseCase,
            categoryId: categoryId,
            targetDate: currentTargetDate
        )
    }
    
    func addTodo(content: String, startTime: Date? = nil) {
        guard let categoryId = selectedCategoryId else {
            print("❌ 카테고리 ID를 찾을 수 없습니다.")
            return
        }
        
        let localAddUseCase = addUseCase
        let targetDate = currentTargetDate
        
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
    
    func monthYearFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        
        return formatter.string(from: date)
    }
    
    func updateDates() {
        var newDates: [Date] = []
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: currentDate)
        components.weekday = startWeekOnSunday ? 1 : 2
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        guard let startOfWeek = calendar.date(from: components) else { return }
        
        for dayOffset in 0...6 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfWeek) {
                newDates.append(date)
            }
        }
        
        DispatchQueue.main.async {
            self.dates = newDates
        }
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
            objectWillChange.send()
            fetchData()
        }
    }
    
    func updateTodoCompletion(_ updatedTodo: TimerTodo) {
        guard var data = todoData else { return }
        
        if let cIndex = data.categories.firstIndex(where: { $0.todos.contains(where: { $0.id == updatedTodo.id }) }),
           let tIndex = data.categories[cIndex].todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            
            let oldTodo = data.categories[cIndex].todos[tIndex]
            data.categories[cIndex].todos[tIndex] = updatedTodo
            
            if oldTodo.isCompleted != updatedTodo.isCompleted {
                let newCompletedCount = updatedTodo.isCompleted
                    ? data.summary.completedCount + 1
                    : data.summary.completedCount - 1
                
                data = TodoData(
                    myPromiseMessage: data.myPromiseMessage,
                    summary: TodoSummary(
                        date: data.summary.date,
                        totalCount: data.summary.totalCount,
                        completedCount: newCompletedCount
                    ),
                    categories: data.categories
                )
            }
            
            todoData = data
        }
    }
    
    func updateMyPromiseMessage(_ newValue: String) {
        Task {
            do {
                _ = try await writeCommitmentMessageUseCase.execute(commitmentMessage: newValue)
                
                fetchData()
            } catch {
                print("❌ 서버 저장 실패: \(error)")
            }
        }
    }
    
    func presentMeatball(for todo: TimerTodo) {
        selectedTodoForMenu = todo
        sheetTodoTitle = todo.content
        sheetTodoId = todo.id
        sheetCategoryName = categoryName(for: todo.id) ?? ""
        sheetStartTime = todo.startTime ?? nil
        // TODO: 미룬이 알림 여부 모델에 추가
        sheetIsAlerted = false
        sheetIsCompleted = todo.isCompleted
        isMeatballSheetPresented = true
    }
    
    func categoryName(for todoID: Int) -> String? {
        guard let categories = todoData?.categories else { return nil }
        for cat in categories {
            if cat.todos.contains(where: { $0.id == todoID }) {
                return cat.name
            }
        }
        return nil
    }
    
    func removeTodo(id: Int, newCompleted: Int, newTotal: Int) {
        guard var data = todoData else { return }
        
        for i in data.categories.indices {
            if let idx = data.categories[i].todos.firstIndex(where: { $0.id == id }) {
                data.categories[i].todos.remove(at: idx)
                break
            }
        }
        
        data = TodoData(
            myPromiseMessage: data.myPromiseMessage,
            summary: TodoSummary(
                date: data.summary.date,
                totalCount: newTotal,
                completedCount: newCompleted
            ),
            categories: data.categories
        )
        
        todoData = data
    }
    
    func replaceTodoStartTime(id: Int, newStartTime: String?) {
        guard var data = todoData else { return }
        for c in data.categories.indices {
            if let idx = data.categories[c].todos.firstIndex(where: { $0.id == id }) {
                data.categories[c].todos[idx].startTime = newStartTime
                break
            }
        }
        todoData = data
    }
    
    func removeTodoAfterReschedule(id: Int) {
        guard var data = todoData else { return }
        for i in data.categories.indices {
            if let idx = data.categories[i].todos.firstIndex(where: { $0.id == id }) {
                data.categories[i].todos.remove(at: idx)
                break
            }
        }
        todoData = data
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

extension TodoViewModel {
    func todoDataTitle(for id: Int) -> String? {
        guard let categories = todoData?.categories else { return nil }
        for cat in categories {
            if let t = cat.todos.first(where: { $0.id == id }) {
                return t.content
            }
        }
        return nil
    }
    
    func todoDataStartTime(for id: Int) -> String? {
        guard let categories = todoData?.categories else { return nil }
        for cat in categories {
            if let t = cat.todos.first(where: { $0.id == id }) {
                return t.startTime
            }
        }
        return nil
    }
    
    func updateTodoTitle(id: Int, newTitle: String) {
        guard var data = todoData else { return }
        for ci in data.categories.indices {
            if let ti = data.categories[ci].todos.firstIndex(where: { $0.id == id }) {
                data.categories[ci].todos[ti].content = newTitle
                todoData = data
                return
            }
        }
    }
    
    func updateTodoStartTime(id: Int, newTime: String?) {
        guard var data = todoData else { return }
        for ci in data.categories.indices {
            if let ti = data.categories[ci].todos.firstIndex(where: { $0.id == id }) {
                data.categories[ci].todos[ti].startTime = newTime
                todoData = data
                return
            }
        }
    }
    
    func todoDataTargetDate(for id: Int) -> Date? {
        guard let categories = todoData?.categories else { return nil }
        for cat in categories {
            if let t = cat.todos.first(where: { $0.id == id }) {
                return t.targetDateAsDate
            }
        }
        return nil
    }
}
