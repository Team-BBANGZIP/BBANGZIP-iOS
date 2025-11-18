//
//  UpdateCategoryOrderUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol UpdateCategoryOrderUseCaseProtocol: Sendable {
    func execute(categoryIds: [Int]) async throws
}

final class UpdateCategoryOrderUseCase: UpdateCategoryOrderUseCaseProtocol {
    private let repository: CategoryOrderRepository
    
    init(repository: CategoryOrderRepository = CategoryOrderRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(categoryIds: [Int]) async throws {
        try await repository.updateOrder(categoryIds: categoryIds)
    }
}
