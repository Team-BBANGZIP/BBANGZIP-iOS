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
