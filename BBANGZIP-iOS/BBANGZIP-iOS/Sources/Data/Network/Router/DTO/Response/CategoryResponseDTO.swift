//
//  CategoryResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

struct CategoryResponseDTO: Decodable, Sendable {
    let code: Int
    let data: [CategoryItemDTO]
}

struct CategoryItemDTO: Decodable, Sendable {
    let categoryId: Int
    let name: String
    let color: String
    let isStopped: Bool
}
