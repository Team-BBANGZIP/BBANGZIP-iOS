//
//  CategoryModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct Category: Identifiable {
    var id: Int { categoryId }
    let categoryId: Int
    var name: String
    var color: Color
    var todos: [TodoItem]
}
