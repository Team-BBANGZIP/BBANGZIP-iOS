//
//  CategoryEditRequestDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

struct CategoryEditRequestDTO: Encodable, Sendable {
    let name: String
    let color: String
    let isStopped: Bool
}

extension CategoryEditRequestDTO {
    init(category: Category) {
        self.name = category.name
        self.color = category.colorType.apiValue
        self.isStopped = category.isStopped
    }
}
