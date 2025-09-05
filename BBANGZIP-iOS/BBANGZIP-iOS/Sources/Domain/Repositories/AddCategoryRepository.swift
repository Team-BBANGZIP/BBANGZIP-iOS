//
//  AddCategoryRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/28/25.
//

import Foundation

protocol AddCategoryRepositoryProtocol: Sendable {
    func addCategory(request: CategoryAddRequestDTO) async throws -> AddCategory
}

final class AddCategoryRepository: AddCategoryRepositoryProtocol {
    
    func addCategory(request: CategoryAddRequestDTO) async throws -> AddCategory {
        // TODO: API 연결 예정
        // 임시 더미 데이터 반환
        return AddCategory(
            categoryId: Int.random(in: 1...1000),
            name: request.name,
            color: request.color,
            isStopped: false
        )
    }
}
