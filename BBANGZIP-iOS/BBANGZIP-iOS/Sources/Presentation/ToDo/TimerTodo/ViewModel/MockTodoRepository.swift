//
//  MockTodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

@MainActor
final class MockTodoRepository: TodoRepository {
    private(set) var todoData: TodoData = TodoData(
        myPromiseMessage: "작은 성취가 모여 큰 성과를 만든다",
        summary: TodoSummary(
            date: "2025-08-31",
            totalCount: 5,
            completedCount: 2
        ),
        categories: [
            Category(
                id: 1,
                name: "모의 카테고리 A",
                colorType: .Todogreen1,
                todos: [
                    TimerTodo(
                        id: 1,
                        content: "할 일 개발하기..",
                        isCompleted: false,
                        startTime: "09:00",
                        colorType: .Todogreen1
                    ),
                    TimerTodo(
                        id: 2,
                        content: "할 일 토익공부하기..",
                        isCompleted: true,
                        startTime: nil,
                        colorType: .Todogreen1
                    )
                ],
                isStopped: false
            ),
            Category(
                id: 2,
                name: "취준",
                colorType: .Todopurple1,
                todos: [
                    TimerTodo(
                        id: 3,
                        content: "자기소개서 쓰기 \n 아아아아",
                        isCompleted: false,
                        startTime: "11:30",
                        colorType: .Todopurple1
                    ),
                    TimerTodo(
                        id: 4,
                        content: "Resume 쓰기",
                        isCompleted: false,
                        startTime: "13:00",
                        colorType: .Todopurple1
                    ),
                    TimerTodo(
                        id: 5,
                        content: "인사하기",
                        isCompleted: true,
                        startTime: nil,
                        colorType: .Todopurple1
                    ),
                    TimerTodo(
                        id: 6,
                        content: "자기소개서 쓰기 \n 아아아아",
                        isCompleted: false,
                        startTime: "11:30",
                        colorType: .Todopurple1
                    ),
                    TimerTodo(
                        id: 7,
                        content: "Resume 쓰기",
                        isCompleted: false,
                        startTime: "13:00",
                        colorType: .Todopurple1
                    ),
                    TimerTodo(
                        id: 8,
                        content: "인사하기",
                        isCompleted: true,
                        startTime: nil,
                        colorType: .Todopurple1
                    )
                ],
                isStopped: true
            ),
            Category(
                id: 3,
                name: "취미",
                colorType: .Todoyellow1,
                todos: [
                    TimerTodo(
                        id: 9,
                        content: "베이스",
                        isCompleted: true,
                        startTime: "16:00",
                        colorType: .Todoyellow1
                    )
                ],
                isStopped: false
            )
        ]
    )
    
    func fetchTodos(
        date: Date,
        accessToken: String
    ) async throws -> TodoData {
        let dateString = DateFormatter.inputDateYMDFormatter.string(from: date)
        
        let newData = TodoData(
            myPromiseMessage: todoData.myPromiseMessage,
            summary: TodoSummary(
                date: dateString,
                totalCount: todoData.summary.totalCount,
                completedCount: todoData.summary.completedCount
            ),
            categories: todoData.categories
        )
        return newData
        
    }
    
    
    func updateTodoCompletion(
        todoId: Int,
        isCompleted: Bool
    ) async throws {
        print("Mock updateTodoCompletion called for id=\(todoId), isCompleted=\(isCompleted)")
    }
    
    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo {
        
        guard let index = todoData.categories.firstIndex(where: { $0.id == categoryId }) else {
            LoggerFactory.create(category: .data)
                .error("Mock AddTodo failed: category not found (id=\(categoryId))")
            
            throw RouterError.server(message: "Category not found: \(categoryId)")
        }
        
        let newTodo = TimerTodo(
            id: UUID().hashValue,
            content: content,
            isCompleted: false,
            startTime: startTime.map { DateFormatter.inputTimeFormatter.string(from: $0) },
            colorType: todoData.categories[index].colorType
        )
        
        todoData.categories[index].todos.append(newTodo)
        
        return newTodo
    }
    
    func updateCategory(_ category: Category) async throws {
        if let idx = todoData.categories.firstIndex(where: { $0.id == category.id }) {
            todoData.categories[idx] = category
        }
    }
    
    func deleteCategory(id: Int) async throws {
        todoData.categories.removeAll { $0.id == id }
    }
    
    func editTodo(id: Int, content: String) async throws {
        for (catIndex, category) in todoData.categories.enumerated() {
            if let todoIndex = category.todos.firstIndex(where: { $0.id == id }) {
                todoData.categories[catIndex].todos[todoIndex].content = content
                print("Mock editTodo: id=\(id) → content='\(content)' 로 변경됨")
                return
            }
        }
        
        LoggerFactory.create(category: .data)
            .error("Mock editTodo failed: Todo not found (id=\(id))")
        throw RouterError.server(message: "Todo not found: \(id)")
    }
    
    func deleteTodo(id: Int) async throws -> (completedCount: Int, totalCount: Int) {
        for catIdx in todoData.categories.indices {
            if let todoIdx = todoData.categories[catIdx].todos.firstIndex(where: { $0.id == id }) {
                let wasCompleted = todoData.categories[catIdx].todos[todoIdx].isCompleted
                todoData.categories[catIdx].todos.remove(at: todoIdx)
                
                let newTotal = todoData.categories.reduce(0) { $0 + $1.todos.count }
                let newCompleted = todoData.categories.reduce(0) { $0 + $1.todos.filter({ $0.isCompleted }).count }
                
                todoData = TodoData(
                    myPromiseMessage: todoData.myPromiseMessage,
                    summary: TodoSummary(
                        date: todoData.summary.date,
                        totalCount: newTotal,
                        completedCount: newCompleted
                    ),
                    categories: todoData.categories
                )
                
                print("Mock deleteTodo: removed id=\(id), wasCompleted=\(wasCompleted)")
                return (newCompleted, newTotal)
            }
        }
        LoggerFactory.create(category: .data)
            .error("Mock deleteTodo failed: Todo not found (id=\(id))")
        throw RouterError.server(message: "Todo not found: \(id)")
    }
    
    func editTodoStartTime(id: Int, startTime: Date) async throws -> String {
        let timeStr = DateFormatter.inputTimeFormatter.string(from: startTime)
        for c in todoData.categories.indices {
            if let t = todoData.categories[c].todos.firstIndex(where: { $0.id == id }) {
                todoData.categories[c].todos[t].startTime = timeStr
                return timeStr
            }
        }
        throw RouterError.server(message: "Todo not found: \(id)")
    }
    
    func rescheduleTodo(id: Int, targetDate: Date?) async throws -> TodoRescheduleDataDTO {
        let dateStr = targetDate.map { DateFormatter.inputDateYMDFormatter.string(from: $0) }
        ?? DateFormatter.inputDateYMDFormatter.string(
            from: Calendar.current.date(
                byAdding: .day,
                value: 1,
                to: Date()
            )!
        )
        
        for c in todoData.categories.indices {
            if let t = todoData.categories[c].todos.firstIndex(where: { $0.id == id }) {
                todoData.categories[c].todos.remove(at: t)
                return TodoRescheduleDataDTO(
                    todoId: id,
                    content: "Mock content",
                    targetDate: dateStr,
                    startTime: "09:00",
                    isCompleted: false
                )
            }
        }
        throw RouterError.server(message: "Todo not found: \(id)")
    }
}
