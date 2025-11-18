//
//  CategoryDeleteRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol CategoryDeleteRepository: Sendable {
    func deleteCategory(id: Int) async throws
}

final class CategoryDeleteRepositoryImpl: CategoryDeleteRepository {
    private let api: API
    
    init(api: API = .shared) {
        self.api = api
    }
    
    func deleteCategory(id: Int) async throws {
        let router = BbangRouter.deleteCategory(id: id)
        
        do {
            let response: CategoryDeleteResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                throw DeleteCategoryError.invalidResponseCode(response.code)
            }
        } catch {
            LoggerFactory.create(category: .data)
                .error("DeleteCategory Error: \(error.localizedDescription)")
            throw error
        }
    }
}

enum DeleteCategoryError: Error {
    case invalidResponseCode(Int)
}
