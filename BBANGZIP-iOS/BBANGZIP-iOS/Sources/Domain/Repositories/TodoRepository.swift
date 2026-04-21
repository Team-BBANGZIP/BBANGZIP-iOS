//
//  TodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

protocol TodoRepository: Sendable {
    func fetchTodos(date: Date) async throws -> TodoData
    func completeTodo(
        todoId: Int,
        isCompleted: Bool
    ) async throws -> TodoComplete
    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo
    func updateCategory(_ category: Category) async throws
    func deleteCategory(id: Int) async throws
    func editTodo(
        id: Int,
        content: String
    ) async throws
    func deleteTodo(id: Int) async throws -> (
        completedCount: Int,
        totalCount: Int
    )
    func editTodoStartTime(
        id: Int,
        startTime: Date?
    ) async throws -> String?
    func rescheduleTodo(
        id: Int,
        targetDate: Date?
    ) async throws -> TodoRescheduleDataDTO
    
    func repeatTodo(
        id: Int,
        targetDate: Date
    ) async throws -> TodoRepeat
    
    func copyTodo(
        id: Int
    ) async throws -> TimerTodo
    
    func reorderTodo(
        request: TodoReorderRequestDTO
    ) async throws -> Bool
}

final class TodoRepositoryImpl: TodoRepository {
    private let api: API
    
    init(api: API = .shared) {
        self.api = api
    }
    
    func fetchTodos(date: Date) async throws -> TodoData {
        let dto = TodoFetchRequestDTO(
            date: DateFormatter.inputDateYMDFormatter.string(from: date)
        )
        
        let router = BbangRouter.fetchTodos(params: dto)
        
        do {
            let response: TodoFetchResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("FetchTodos Error: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("FetchTodos Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func completeTodo(todoId: Int, isCompleted: Bool) async throws -> TodoComplete {
        let dto = TodoCompleteRequestDTO(isCompleted: isCompleted)
        let router = BbangRouter.completeTodo(id: todoId, dto: dto)
        
        do {
            let response: TodoCompleteResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("CompleteTodo Error: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("CompleteTodo Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func addTodo(
        categoryId: Int,
        content: String,
        targetDate: Date,
        startTime: Date?
    ) async throws -> TimerTodo {
        let dto = TodoAddRequestDTO(
            categoryId: categoryId,
            content: content,
            targetDate: DateFormatter.inputDateYMDFormatter.string(from: targetDate),
            startTime: startTime.map { DateFormatter.inputTimeFormatter.string(from: $0) }
        )
        
        let router = BbangRouter.addTodo(dto: dto)
        
        do {
            let response: TodoAddResponseDTO = try await api.request(api: router)
            
            let okCodes: Set<Int> = [20000, 20100]
            if !okCodes.contains(response.code) {
                LoggerFactory.create(category: .data)
                    .error("AddTodo Error: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("AddTodo Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func editTodo(id: Int, content: String) async throws {
        let dto = TodoEditRequestDTO(content: content)
        let router = BbangRouter.editTodo(id: id, dto: dto)
        
        do {
            let response: BaseResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("EditTodo Error: Unexpected response code \(response.code)")
            }
        } catch {
            LoggerFactory.create(category: .data)
                .error("EditTodo Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateCategory(_ category: Category) async throws {}
    func deleteCategory(id: Int) async throws {}
    
    func deleteTodo(id: Int) async throws -> (completedCount: Int, totalCount: Int) {
        let router = BbangRouter.deleteTodo(id: id)
        
        do {
            let response: TodoDeleteResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("DeleteTodo Error: Unexpected response code \(response.code)")
            }
            return (response.data.completedCount, response.data.totalCount)
        } catch {
            LoggerFactory.create(category: .data)
                .error("DeleteTodo Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func editTodoStartTime(id: Int, startTime: Date?) async throws -> String? {
//        let timeStr = DateFormatter.inputTimeFormatter.string(from: startTime)
        let timeStr = startTime.map {
            DateFormatter.inputTimeFormatter.string(from: $0)
        }
        let dto = TodoStartTimeEditRequestDTO(startTime: timeStr)
        let router = BbangRouter.updateTodoStartTime(id: id, dto: dto)
        
        do {
            let response: TodoStartTimeEditResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("EditTodoStartTime Error: Unexpected response code \(response.code)")
            }
            return response.data.startTime
        } catch {
            LoggerFactory.create(category: .data)
                .error("EditTodoStartTime Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func rescheduleTodo(id: Int, targetDate: Date?) async throws -> TodoRescheduleDataDTO {
        let dateStr = targetDate.map {
            DateFormatter.inputDateYMDFormatter.string(from: $0)
        }
        let dto = TodoRescheduleRequestDTO(targetDate: dateStr)
        let router = BbangRouter.rescheduleTodo(id: id, dto: dto)
        
        do {
            let response: TodoRescheduleResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("RescheduleTodo Error: Unexpected response code \(response.code)")
            }
            return response.data
        } catch {
            LoggerFactory.create(category: .data)
                .error("RescheduleTodo Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func repeatTodo(id: Int, targetDate: Date) async throws -> TodoRepeat {
        let dto = TodoRepeatRequestDTO(targetDate: DateFormatter.inputDateYMDFormatter.string(from: targetDate))
        let router = BbangRouter.repeatTodo(id: id, dto: dto)
        
        do {
            let response: TodoRepeatResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("RepeatTodo Error: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("RepeatTodo Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func copyTodo(id: Int) async throws -> TimerTodo {
        let router = BbangRouter.copyTodo(id: id)
        
        do {
            let response: TodoCopyResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("CopyTodo Error: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("CopyTodo Request Failed: \(error.localizedDescription)")
            
            throw error
        }
    }
    
    func reorderTodo(
        request: TodoReorderRequestDTO
    ) async throws -> Bool {
        let dto = TodoReorderRequestDTO(
            todoId: request.todoId,
            originCategoryId: request.originCategoryId,
            targetCategoryId: request.targetCategoryId,
            targetCategoryColor: request.targetCategoryColor,
            todoList: request.todoList
        )
        
        let router = BbangRouter.reorderTodo(dto: dto)
        
        do {
            let response: BaseResponseDTO = try await api.request(api: router)
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("ReorderTodo Error: Unexpected response code \(response.code)")
            }
            return true
        } catch {
            LoggerFactory.create(category: .data)
                .error("Reorder Todo Request Failed: \(error.localizedDescription)")
            
            throw error
        }
    }
}
