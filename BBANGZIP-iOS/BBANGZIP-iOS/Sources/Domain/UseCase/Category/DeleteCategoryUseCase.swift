//
//  DeleteCategoryUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol DeleteCategoryUseCaseProtocol: Sendable {
    func deleteCategory(id: Int) async throws
}

final class DeleteCategoryUseCase: DeleteCategoryUseCaseProtocol {
    private let repository: CategoryDeleteRepository
    
    init(repository: CategoryDeleteRepository = CategoryDeleteRepositoryImpl()) {
        self.repository = repository
    }
    
    func deleteCategory(id: Int) async throws {
        try await repository.deleteCategory(id: id)
    }
}
