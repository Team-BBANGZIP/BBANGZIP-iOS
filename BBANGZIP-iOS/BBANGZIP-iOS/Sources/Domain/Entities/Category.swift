//
//  Category.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import Foundation

struct Category: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let colorType: CategoryColor
    var todos: [TimerTodo]
    var isStopped: Bool
}

extension Category {
    init(dto: CategoryItemDTO) {
        self.id = dto.categoryId
        self.name = dto.name
        self.colorType = CategoryColor.fromAPI(dto.color)
        self.todos = []
        self.isStopped = dto.isStopped
    }
}
