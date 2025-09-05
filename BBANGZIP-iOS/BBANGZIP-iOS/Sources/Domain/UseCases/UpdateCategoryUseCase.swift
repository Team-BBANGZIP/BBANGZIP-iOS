//
//  UpdateCategoryUseCaseProtocol.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import Foundation

protocol UpdateCategoryUseCaseProtocol: Sendable {
    func updateCategory(
        id: Int,
        name: String,
        color: String,
        isStopped: Bool
    ) async throws -> UpdateCategory
}

final class UpdateCategoryUseCase: UpdateCategoryUseCaseProtocol, @unchecked Sendable {
    private let repository: UpdateCategoryRepositoryProtocol
    init(repository: UpdateCategoryRepositoryProtocol = UpdateCategoryRepository()) {
        self.repository = repository
    }
    func updateCategory(
        id: Int,
        name: String,
        color: String,
        isStopped: Bool
    ) async throws -> UpdateCategory {
        let req = CategoryUpdateRequestDTO(
            name: name,
            color: color,
            isStopped: isStopped
        )
        return try await repository.updateCategory(id: id, request: req)
    }
}
