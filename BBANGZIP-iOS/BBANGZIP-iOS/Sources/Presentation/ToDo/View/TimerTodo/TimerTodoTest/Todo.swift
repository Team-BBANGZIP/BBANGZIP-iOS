//
//  Todo.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/29/25.
//

import SwiftUI

struct Todo: Identifiable, Hashable {
    let id: Int
    let content: String
    let isCompleted: Bool
    let startTime: String?
    var color: Color
}
