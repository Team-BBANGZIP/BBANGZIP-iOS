//
//  TodoDeleteResponseDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/28/25.
//

import Foundation

struct TodoDeleteResponseDTO: Decodable {
    let code: Int
    let data: TodoDeleteDataDTO
}

struct TodoDeleteDataDTO: Decodable {
    let completedCount: Int
    let totalCount: Int
}
