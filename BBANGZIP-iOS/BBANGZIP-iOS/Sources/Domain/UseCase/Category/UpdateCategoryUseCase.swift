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
    ) async throws -> Category
}

final class UpdateCategoryUseCase: UpdateCategoryUseCaseProtocol {
    private let repository: CategoryUpdateRepository
    
    init(repository: CategoryUpdateRepository = CategoryUpdateRepositoryImpl()) {
        self.repository = repository
    }
    
    func updateCategory(
        id: Int,
        name: String,
        color: String,
        isStopped: Bool
    ) async throws -> Category {
        try await repository.updateCategory(
            id: id,
            name: name,
            color: color,
            isStopped: isStopped
        )
    }
}
