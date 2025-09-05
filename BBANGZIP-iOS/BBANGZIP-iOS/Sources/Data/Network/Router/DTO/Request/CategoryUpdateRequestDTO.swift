//
//  CategoryUpdateRequestDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import Foundation

struct CategoryUpdateRequestDTO: Encodable {
    let name: String
    let color: String
    let isStopped: Bool
}
