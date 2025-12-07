//
//  BreadCountRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

protocol BreadCountRepository: Sendable {
    func getTodayBreadCount() async throws -> BreadCount
}

final class BreadCountRepositoryImpl: BreadCountRepository {
    private let api: API

    init(
        api: API = .shared
    ) {
        self.api = api
    }
    
    func getTodayBreadCount() async throws -> BreadCount {
        let router = BbangRouter.getTodayBreadCount
        
        do {
            let response: BreadCountResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("getTodayBreadCount: Unexpected response code \(response.code)")
            }
            return response.data.toDomain()
        } catch {
            LoggerFactory.create(category: .data)
                .error("getTodayBreadCount: \(error.localizedDescription)")
            
            throw error
        }
    }
}
