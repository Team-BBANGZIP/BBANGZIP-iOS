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
    let isVisible: Bool
}
