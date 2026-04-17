//
//  TodoStartTimeEditResponseDTO.swift
//  BBANGZIP
//
//  Created by 김송희 on 10/28/25.
//

import Foundation

struct TodoStartTimeEditResponseDTO: Decodable {
    let code: Int
    let data: TodoStartTimeEditDataDTO
}

struct TodoStartTimeEditDataDTO: Decodable {
    let todoId: Int
    let startTime: String?
}
