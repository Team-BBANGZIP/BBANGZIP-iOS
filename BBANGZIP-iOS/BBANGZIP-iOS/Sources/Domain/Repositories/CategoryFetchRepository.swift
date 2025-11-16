//
//  CategoryFetchRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/16/25.
//

import Foundation

protocol CategoryFetchRepository: Sendable {
    func fetchCategories() async throws -> [Category]
}

final class CategoryFetchRepositoryImpl: CategoryFetchRepository {
    private let api: API
    
    init(api: API = .shared) {
        self.api = api
    }
    
    func fetchCategories() async throws -> [Category] {
        let requestDTO = CategoryFetchRequestDTO()
        let router = BbangRouter.fetchCategories(params: requestDTO)
        
        do {
            let response: CategoryResponseDTO = try await api.request(api: router)
            return response.data.map { Category(dto: $0) }
        } catch {
            LoggerFactory.create(category: .data)
                .error("FetchCategories Error: \(error.localizedDescription)")
            throw error
        }
    }
}
