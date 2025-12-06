//
//  CategoryOrderUpdateDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

struct CategoryOrderUpdateRequestDTO: Encodable, Sendable {
    let categoryOrder: [Int]
}

struct CategoryOrderUpdateResponseDTO: Decodable, Sendable {
    let code: Int
}
