//
//  CategoryEditResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

struct CategoryEditResponseDTO: Decodable, Sendable {
    let code: Int
    let data: CategoryItemDTO
}

extension CategoryEditResponseDTO {
    func toEntity() -> Category {
        Category(dto: data)
    }
}
