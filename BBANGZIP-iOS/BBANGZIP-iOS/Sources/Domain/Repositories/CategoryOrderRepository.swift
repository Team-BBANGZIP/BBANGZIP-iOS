//
//  CategoryOrderRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol CategoryOrderRepository: Sendable {
    func updateOrder(categoryIds: [Int]) async throws
}

enum UpdateCategoryOrderError: Error {
    case invalidResponseCode(Int)
}

final class CategoryOrderRepositoryImpl: CategoryOrderRepository {
    private let api: API
    
    init(api: API = .shared) {
        self.api = api
    }
    
    func updateOrder(categoryIds: [Int]) async throws {
        let requestDTO = CategoryOrderUpdateRequestDTO(categoryOrder: categoryIds)
        let router = BbangRouter.updateCategoryOrder(dto: requestDTO)
        
        do {
            let response: CategoryOrderUpdateResponseDTO = try await api.request(api: router)
            
            guard response.code == 20000 else {
                throw UpdateCategoryOrderError.invalidResponseCode(response.code)
            }
        } catch {
            LoggerFactory.create(category: .data)
                .error("UpdateCategoryOrder Error: \(error.localizedDescription)")
            throw error
        }
    }
}
