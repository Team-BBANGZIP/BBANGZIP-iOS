//
//  AddCategoryUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/28/25.
//

import Foundation

protocol AddCategoryUseCaseProtocol: Sendable {
    func addCategory(
        name: String,
        color: String
    ) async throws -> AddCategory
}

final class AddCategoryUseCase: AddCategoryUseCaseProtocol, @unchecked Sendable {
    private let repository: AddCategoryRepositoryProtocol
    
    init(repository: AddCategoryRepositoryProtocol = AddCategoryRepository()) {
        self.repository = repository
    }
    
    func addCategory(
        name: String,
        color: String
    ) async throws -> AddCategory {
        let request = CategoryAddRequestDTO(
            name: name,
            color: color
        )
        return try await repository.addCategory(request: request)
    }
}
