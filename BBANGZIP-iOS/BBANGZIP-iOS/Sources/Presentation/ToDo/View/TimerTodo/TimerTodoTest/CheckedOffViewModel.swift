//
//  CheckedOffViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

class CheckedOffViewModel: ObservableObject {
    @Published var categories: [Category] = [
        Category(
            categoryId: 1,
            name: "제과제빵점",
            color: Color(.todored1),
            todos: [
                TodoItem(
                    todoId: 11,
                    content: "Lo-Fi Wireframe 회의",
                    isCompleted: true,
                    startTime: "23:00"
                ),
                TodoItem(
                    todoId: 12,
                    content: "Hi-Fi Wireframe 확정",
                    isCompleted: false,
                    startTime: "13:00"
                ),
                TodoItem(
                    todoId: 13,
                    content: "기능 명세서 확정",
                    isCompleted: true,
                    startTime: nil
                )
            ]
        ),
        Category(
            categoryId: 2,
            name: "경제학개론",
            color: Color(.todoblue1),
            todos: [
                TodoItem(
                    todoId: 21,
                    content: "경제학 과제 제출",
                    isCompleted: true,
                    startTime: nil
                ),
                TodoItem(
                    todoId: 22,
                    content: "PPT 32p~36p 읽기",
                    isCompleted: false,
                    startTime: nil
                )
            ]
        )
    ]
    
    @Published var isSheetPresented: Bool = false
}
