//
//  TodoRescheduleResponseDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/28/25.
//

import Foundation

struct TodoRescheduleResponseDTO: Decodable {
    let code: Int
    let data: TodoRescheduleDataDTO
}

struct TodoRescheduleDataDTO: Decodable {
    let todoId: Int
    let content: String
    let targetDate: String
    let startTime: String?
    let isCompleted: Bool
}
