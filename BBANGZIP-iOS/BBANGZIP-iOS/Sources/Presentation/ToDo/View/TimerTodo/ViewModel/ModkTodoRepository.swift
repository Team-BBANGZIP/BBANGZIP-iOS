//
//  ModkTodoRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 6/4/25.
//

import Foundation
import SwiftUI

struct MockTodoRepository: TodoRepository {
    func fetchTimerTodos() async throws -> [Category] {
        let greenColor = Color(.todogreen1)
        let purpleColor = Color(.todopurple1)
        let yellowColor = Color(.todoyellow1)
        
        return [
            Category(
                id: 1,
                name: "모의 카테고리 A",
                color: greenColor,
                todos: [
                    TimerTodo(
                        id: 1,
                        content: "할 일 개발하기..",
                        isCompleted: false,
                        startTime: "09:00",
                        color: greenColor
                    ),
                    TimerTodo(
                        id: 2,
                        content: "할 일 토익공부하기..",
                        isCompleted: true,
                        startTime: nil,
                        color: greenColor
                    )
                ]
            ),
            Category(
                id: 2,
                name: "취준",
                color: purpleColor,
                todos: [
                    TimerTodo(
                        id: 3,
                        content: "자기소개서 쓰기",
                        isCompleted: false,
                        startTime: "11:30",
                        color: purpleColor
                    ),
                    TimerTodo(
                        id: 4,
                        content: "Resume 쓰기",
                        isCompleted: false,
                        startTime: "13:00",
                        color: purpleColor
                    ),
                    TimerTodo(
                        id: 5,
                        content: "인사하기",
                        isCompleted: true,
                        startTime: nil,
                        color: purpleColor
                    )
                ]
            ),
            Category(
                id: 3,
                name: "취미",
                color: yellowColor,
                todos: [
                    TimerTodo(
                        id: 6,
                        content: "베이스",
                        isCompleted: true,
                        startTime: "16:00",
                        color: yellowColor
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
