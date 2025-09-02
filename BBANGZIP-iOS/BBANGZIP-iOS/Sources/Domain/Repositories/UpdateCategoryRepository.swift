//
//  UpdateCategoryRepository.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import Foundation

protocol UpdateCategoryRepositoryProtocol: Sendable {
    func updateCategory(id: Int, request: CategoryUpdateRequestDTO) async throws -> UpdateCategory
}

final class UpdateCategoryRepository: UpdateCategoryRepositoryProtocol {
    func updateCategory(id: Int, request: CategoryUpdateRequestDTO) async throws -> UpdateCategory {
        // TODO: 실제 네트워크 연동
        return UpdateCategory(
            categoryId: Int.random(in: 1...1000),
            name: request.name,
            color: request.color,
            isStopped: request.isStopped
        )
    }
}
