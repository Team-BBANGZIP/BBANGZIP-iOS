//
//  CategoryUpdateRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol CategoryUpdateRepository: Sendable {
    func updateCategory(
        id: Int,
        name: String,
        color: String,
        isStopped: Bool
    ) async throws -> Category
}

final class CategoryUpdateRepositoryImpl: CategoryUpdateRepository {
    private let api: API
    
    init(api: API = .shared) {
        self.api = api
    }
    
    func updateCategory(
        id: Int,
        name: String,
        color: String,
        isStopped: Bool
    ) async throws -> Category {
        let requestDTO = CategoryEditRequestDTO(
            name: name,
            color: color,
            isStopped: isStopped
        )
        
        let router = BbangRouter.editCategory(id: id, dto: requestDTO)
        
        do {
            let response: CategoryEditResponseDTO = try await api.request(api: router)
            return response.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("UpdateCategory Error: \(error.localizedDescription)")
            throw error
        }
    }
}
