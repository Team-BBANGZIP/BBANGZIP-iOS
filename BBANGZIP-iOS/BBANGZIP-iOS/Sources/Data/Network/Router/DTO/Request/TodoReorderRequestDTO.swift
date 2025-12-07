//
//  TodoReorderRequestDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/19/25.
//

import Foundation

struct TodoReorderRequestDTO: Encodable {
    let todoId: Int
    let originCategoryId: Int
    let targetCategoryId: Int
    let targetCategoryColor: String
    let todoList: [Int]
}
