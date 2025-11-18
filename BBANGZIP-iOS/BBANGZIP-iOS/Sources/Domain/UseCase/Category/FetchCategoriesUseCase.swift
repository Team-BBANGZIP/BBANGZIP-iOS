//
//  FetchCategoriesUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol FetchCategoriesUseCase: Sendable {
    func execute() async throws -> [Category]
}

final class FetchCategoriesUseCaseImpl: FetchCategoriesUseCase {
    private let repository: CategoryFetchRepository

    init(repository: CategoryFetchRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Category] {
        try await repository.fetchCategories()
    }
}
