//
//  CategoryModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    var id: Int { categoryId }
    let categoryId: Int
    let name: String
    let color: Color
}
