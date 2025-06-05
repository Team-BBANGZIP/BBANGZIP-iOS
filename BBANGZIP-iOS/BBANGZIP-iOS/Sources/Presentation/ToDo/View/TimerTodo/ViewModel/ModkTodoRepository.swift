//
//  MockTodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation

struct MockTodoRepository: TodoRepository {
    func fetchTimerTodos() async throws -> [Category] {
        return [
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
                ]
            ),
            Category(
                id: 2,
                name: "취준",
                colorType: .Todopurple1,
                todos: [
                    TimerTodo(
                        id: 3,
                        content: "자기소개서 쓰기",
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
                    )
                ]
            ),
            Category(
                id: 3,
                name: "취미",
                colorType: .Todoyellow1,
                todos: [
                    TimerTodo(
                        id: 6,
                        content: "베이스",
                        isCompleted: true,
                        startTime: "16:00",
                        colorType: .Todoyellow1
                    )
                ]
            )
        ]
    }
    
    func updateTodoCompletion(
        todoId: Int,
        isCompleted: Bool
    ) async throws {
        print("✅ Mock updateTodoCompletion called for id=\(todoId), isCompleted=\(isCompleted)")
    }
}
