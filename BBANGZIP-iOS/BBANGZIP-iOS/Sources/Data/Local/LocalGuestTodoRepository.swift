import Foundation

final class LocalGuestTodoRepository: TodoRepository, @unchecked Sendable {
    private let store: LocalGuestTodoStore

    init(store: LocalGuestTodoStore = .shared) {
        self.store = store
    }

    func fetchTodos(date: Date) async throws -> TodoData {
        store.todoData(for: date)
    }

    func completeTodo(todoId: Int, isCompleted: Bool) async throws -> TodoComplete {
        try store.updateTodo(id: todoId) { todo in
            todo.isCompleted = isCompleted
        }

        let data = store.todoDataContainingTodo(id: todoId)
        return TodoComplete(
            todoId: todoId,
            isCompleted: isCompleted,
            completedCount: data.summary.completedCount,
            totalCount: data.summary.totalCount
        )
    }

    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo {
        try store.addTodo(
            categoryId: categoryId,
            content: content,
            targetDate: targetDate,
            startTime: startTime
        )
    }

    func updateCategory(_ category: Category) async throws {
        try store.updateCategory(category)
    }

    func deleteCategory(id: Int) async throws {
        try store.deleteCategory(id: id)
    }

    func editTodo(id: Int, content: String) async throws {
        try store.updateTodo(id: id) { todo in
            todo.content = content
        }
    }

    func deleteTodo(id: Int) async throws -> (completedCount: Int, totalCount: Int) {
        let targetDate = try store.deleteTodo(id: id)
        let data = store.todoData(for: targetDate)
        return (data.summary.completedCount, data.summary.totalCount)
    }

    func editTodoStartTime(id: Int, startTime: Date?) async throws -> String? {
        let timeString = startTime.map { DateFormatter.inputTimeFormatter.string(from: $0) }
        try store.updateTodo(id: id) { todo in
            todo.startTime = timeString
        }
        return timeString
    }

    func rescheduleTodo(id: Int, targetDate: Date?) async throws -> TodoRescheduleDataDTO {
        let dateString = targetDate.map { DateFormatter.inputDateYMDFormatter.string(from: $0) }
        let updated = try store.updateTodo(id: id) { todo in
            todo.targetDate = dateString
        }
        return TodoRescheduleDataDTO(
            todoId: updated.id,
            content: updated.content,
            targetDate: updated.targetDate ?? "",
            startTime: updated.startTime,
            isCompleted: updated.isCompleted
        )
    }

    func repeatTodo(id: Int, targetDate: Date) async throws -> TodoRepeat {
        let copied = try store.copyTodo(id: id, targetDate: targetDate)
        return TodoRepeat(
            todoId: copied.id,
            content: copied.content,
            targetDate: copied.targetDate ?? "",
            startTime: copied.startTime,
            isCompleted: copied.isCompleted
        )
    }

    func copyTodo(id: Int) async throws -> TimerTodo {
        try store.copyTodo(id: id, targetDate: nil)
    }

    func reorderTodo(request: TodoReorderRequestDTO) async throws -> Bool {
        try store.reorderTodo(request: request)
        return true
    }
}

enum LocalGuestTodoError: Error {
    case missingCategory
    case missingTodo
}

final class LocalGuestTodoStore: @unchecked Sendable {
    static let shared = LocalGuestTodoStore()

    private struct State: Codable {
        var nextCategoryId: Int
        var nextTodoId: Int
        var myPromiseMessage: String
        var categories: [Category]
        var timerBreadCountByDate: [String: Int]
    }

    private let key = "guest.todo.state.v1"
    private let defaults: UserDefaults
    private let lock = NSLock()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func todoData(for date: Date) -> TodoData {
        let dateString = DateFormatter.inputDateYMDFormatter.string(from: date)
        return todoData(for: dateString)
    }

    func todoDataContainingTodo(id: Int) -> TodoData {
        let state = loadState()
        let targetDate = state.categories
            .flatMap(\.todos)
            .first { $0.id == id }?
            .targetDate ?? DateFormatter.inputDateYMDFormatter.string(from: Date())

        return todoData(for: targetDate)
    }

    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) throws -> TimerTodo {
        try mutateState { state in
            guard let categoryIndex = state.categories.firstIndex(where: { $0.id == categoryId }) else {
                throw LocalGuestTodoError.missingCategory
            }

            let dateString = DateFormatter.inputDateYMDFormatter.string(from: targetDate)
            let todo = TimerTodo(
                id: state.nextTodoId,
                content: content,
                isCompleted: false,
                startTime: startTime.map { DateFormatter.inputTimeFormatter.string(from: $0) },
                colorType: state.categories[categoryIndex].colorType,
                targetDate: dateString
            )

            state.nextTodoId += 1
            state.categories[categoryIndex].todos.append(todo)
            return todo
        }
    }

    @discardableResult
    func updateTodo(id: Int, transform: (inout TimerTodo) -> Void) throws -> TimerTodo {
        try mutateState { state in
            for categoryIndex in state.categories.indices {
                if let todoIndex = state.categories[categoryIndex].todos.firstIndex(where: { $0.id == id }) {
                    transform(&state.categories[categoryIndex].todos[todoIndex])
                    return state.categories[categoryIndex].todos[todoIndex]
                }
            }

            throw LocalGuestTodoError.missingTodo
        }
    }

    func deleteTodo(id: Int) throws -> Date {
        let targetDateString = try mutateState { state in
            for categoryIndex in state.categories.indices {
                if let todoIndex = state.categories[categoryIndex].todos.firstIndex(where: { $0.id == id }) {
                    let todo = state.categories[categoryIndex].todos.remove(at: todoIndex)
                    return todo.targetDate ?? DateFormatter.inputDateYMDFormatter.string(from: Date())
                }
            }

            throw LocalGuestTodoError.missingTodo
        }

        return DateFormatter.inputDateYMDFormatter.date(from: targetDateString) ?? Date()
    }

    func updateCategory(_ category: Category) throws {
        try mutateState { state in
            guard let index = state.categories.firstIndex(where: { $0.id == category.id }) else {
                throw LocalGuestTodoError.missingCategory
            }

            state.categories[index] = Category(
                id: category.id,
                name: category.name,
                colorType: category.colorType,
                todos: state.categories[index].todos.map { $0.withUpdatedColorType(category.colorType) },
                isStopped: category.isStopped
            )
        }
    }

    func deleteCategory(id: Int) throws {
        try mutateState { state in
            guard state.categories.contains(where: { $0.id == id }) else {
                throw LocalGuestTodoError.missingCategory
            }

            state.categories.removeAll { $0.id == id }
            if state.categories.isEmpty {
                state.categories.append(Self.defaultCategory)
                state.nextCategoryId = max(state.nextCategoryId, 2)
            }
        }
    }

    func copyTodo(id: Int, targetDate: Date?) throws -> TimerTodo {
        try mutateState { state in
            for categoryIndex in state.categories.indices {
                if let source = state.categories[categoryIndex].todos.first(where: { $0.id == id }) {
                    let copied = TimerTodo(
                        id: state.nextTodoId,
                        content: source.content,
                        isCompleted: false,
                        startTime: source.startTime,
                        colorType: source.colorType,
                        targetDate: targetDate.map { DateFormatter.inputDateYMDFormatter.string(from: $0) } ?? source.targetDate
                    )

                    state.nextTodoId += 1
                    state.categories[categoryIndex].todos.append(copied)
                    return copied
                }
            }

            throw LocalGuestTodoError.missingTodo
        }
    }

    func reorderTodo(request: TodoReorderRequestDTO) throws {
        try mutateState { state in
            var movingTodo: TimerTodo?
            for categoryIndex in state.categories.indices {
                if let todoIndex = state.categories[categoryIndex].todos.firstIndex(where: { $0.id == request.todoId }) {
                    movingTodo = state.categories[categoryIndex].todos.remove(at: todoIndex)
                    break
                }
            }

            guard var todo = movingTodo else {
                throw LocalGuestTodoError.missingTodo
            }

            guard let targetIndex = state.categories.firstIndex(where: { $0.id == request.targetCategoryId }) else {
                throw LocalGuestTodoError.missingCategory
            }

            todo = todo.withUpdatedColorType(state.categories[targetIndex].colorType)
            let targetOrder = request.todoList.filter { $0 != request.todoId }
            var targetTodos = state.categories[targetIndex].todos.filter { !targetOrder.contains($0.id) }
            let ordered = targetOrder.compactMap { id in
                state.categories[targetIndex].todos.first { $0.id == id }
            }
            targetTodos = ordered + targetTodos
            targetTodos.append(todo)
            state.categories[targetIndex].todos = targetTodos
        }
    }

    func addTimerBreadCount(_ count: Int, targetDate: Date = Date()) {
        try? mutateState { state in
            let dateString = DateFormatter.inputDateYMDFormatter.string(from: targetDate)
            state.timerBreadCountByDate[dateString, default: 0] += count
        }
    }

    func todayBreadCount() -> Int {
        let dateString = DateFormatter.inputDateYMDFormatter.string(from: Date())
        return loadState().timerBreadCountByDate[dateString, default: 0]
    }
    
    func updatePromiseMessage(_ message: String) {
        try? mutateState { state in
            state.myPromiseMessage = message
        }
    }

    private func todoData(for dateString: String) -> TodoData {
        let state = loadState()
        let categories = state.categories.map { category in
            Category(
                id: category.id,
                name: category.name,
                colorType: category.colorType,
                todos: category.todos.filter { ($0.targetDate ?? dateString) == dateString },
                isStopped: category.isStopped
            )
        }

        let todos = categories.flatMap(\.todos)
        return TodoData(
            myPromiseMessage: state.myPromiseMessage,
            summary: TodoSummary(
                date: dateString,
                totalCount: todos.count,
                completedCount: todos.filter(\.isCompleted).count
            ),
            categories: categories
        )
    }

    private func loadState() -> State {
        lock.lock()
        defer { lock.unlock() }

        guard let data = defaults.data(forKey: key),
              let state = try? JSONDecoder().decode(State.self, from: data) else {
            return Self.defaultState
        }

        return state.categories.isEmpty ? Self.defaultState : state
    }

    private func saveState(_ state: State) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        defaults.set(data, forKey: key)
    }

    @discardableResult
    private func mutateState<T>(_ mutation: (inout State) throws -> T) throws -> T {
        lock.lock()
        defer { lock.unlock() }

        var state: State
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode(State.self, from: data),
           !decoded.categories.isEmpty {
            state = decoded
        } else {
            state = Self.defaultState
        }

        let result = try mutation(&state)
        saveState(state)
        return result
    }

    private static var defaultState: State {
        State(
            nextCategoryId: 2,
            nextTodoId: 2,
            myPromiseMessage: "나만의 다짐을 적어보세요",
            categories: [defaultCategory],
            timerBreadCountByDate: [:]
        )
    }

    private static var defaultCategory: Category {
        Category(
            id: 1,
            name: "Welcome",
            colorType: .Todored1,
            todos: [
                TimerTodo(
                    id: 1,
                    content: "제과제빵점에 오신걸 환영합니다.",
                    isCompleted: false,
                    startTime: nil,
                    colorType: .Todored1,
                    targetDate: DateFormatter.inputDateYMDFormatter.string(from: Date())
                )
            ],
            isStopped: false
        )
    }
}
