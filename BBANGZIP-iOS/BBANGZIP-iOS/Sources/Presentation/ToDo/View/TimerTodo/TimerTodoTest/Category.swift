//
//  Category.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    let id: Int
    let name: String
    let color: Color
    let todos: [Todo]
}
