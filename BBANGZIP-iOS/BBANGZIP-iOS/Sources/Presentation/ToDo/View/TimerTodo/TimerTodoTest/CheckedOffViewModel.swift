//
//  CheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

class CheckedOffViewModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var isSheetPresented: Bool = false
    
    init() {
        let rawCategories: [Category] = [
            Category(
                categoryId: 1,
                name: "제과제빵점",
                color: Color(.todored1),
                todos: [
                    TodoItem(todoId: 11, content: "Lo-Fi Wireframe 회의", isCompleted: true, startTime: "23:00"),
                    TodoItem(todoId: 12, content: "Hi-Fi Wireframe 확정", isCompleted: false, startTime: "13:00"),
                    TodoItem(todoId: 13, content: "기능 명세서 확정", isCompleted: true, startTime: nil)
                ]
            ),
            Category(
                categoryId: 2,
                name: "경제학개론",
                color: Color(.todoblue1),
                todos: [
                    TodoItem(todoId: 21, content: "경제학 과제 제출", isCompleted: true, startTime: "09:00"),
                    TodoItem(todoId: 22, content: "PPT 32p~36p 읽기", isCompleted: false, startTime: nil)
                ]
            ),
            Category(
                categoryId: 3,
                name: "스터디모임",
                color: Color(.todogreen1),
                todos: [
                    TodoItem(todoId: 31, content: "영어 단어 복습", isCompleted: false, startTime: "07:00"),
                    TodoItem(todoId: 32, content: "지난 주 발표 피드백", isCompleted: false, startTime: nil)
                ]
            ),
            Category(
                categoryId: 4,
                name: "헬스 루틴",
                color: Color(.todoyellow1),
                todos: [
                    TodoItem(todoId: 41, content: "스쿼트 3세트", isCompleted: true, startTime: "06:30"),
                    TodoItem(todoId: 42, content: "스트레칭 10분", isCompleted: false, startTime: nil)
                ]
            ),
            Category(
                categoryId: 5,
                name: "사이드 프로젝트",
                color: Color(.todopurple1),
                todos: [
                    TodoItem(todoId: 51, content: "Figma 디자인 리뷰", isCompleted: false, startTime: "22:00"),
                    TodoItem(todoId: 52, content: "SwiftUI 코드 정리", isCompleted: false, startTime: nil)
                ]
            )
        ]
        
        self.categories = rawCategories.map { category in
            let updatedTodos = category.todos.map { todo -> TodoItem in
                var mutableTodo = todo
                mutableTodo.color = category.color
                return mutableTodo
            }
            return Category(
                categoryId: category.categoryId,
                name: category.name,
                color: category.color,
                todos: updatedTodos
            )
        }
    }
}
