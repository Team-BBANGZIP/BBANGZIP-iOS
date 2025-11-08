//
//  CategoryAddResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/28/25.
//

import Foundation

struct CategoryAddResponseDTO: Decodable {
    let code: Int
    let data: CategoryDataDTO
}

struct CategoryDataDTO: Decodable {
    let categoryId: Int
    let name: String
    let color: String
    let isStopped: Bool
}

extension CategoryDataDTO {
    func toAddCategory() -> AddCategory {
        AddCategory(
            categoryId: categoryId,
            name: name,
            color: color,
            isStopped: isStopped
        )
    }

    func toCategoryEntity() -> Category {
        let mapped = CategoryColor.fromAPI(color)
        return Category(
            id: categoryId,
            name: name,
            colorType: mapped,
            todos: [],
            isStopped: isStopped
        )
    }
}
