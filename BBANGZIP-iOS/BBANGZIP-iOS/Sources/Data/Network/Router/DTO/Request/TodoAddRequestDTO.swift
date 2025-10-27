//
//  TodoAddRequestDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/27/25.
//

import Foundation

struct TodoAddRequestDTO: Encodable {
    let categoryId: Int
    let content: String
    let targetDate: String
    let startTime: String?
}
