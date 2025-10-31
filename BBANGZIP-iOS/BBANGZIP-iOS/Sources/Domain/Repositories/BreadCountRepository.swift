//
//  BreadCountRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

protocol BreadCountRepository: Sendable {
    func getTodayBreadCount(
        accessToken: String
    ) async throws -> BreadCount
}

final class BreadCountRepositoryImpl: BreadCountRepository {
    private let api: API
    private let tokenManager: TokenManager

    init(
        api: API = API(),
        tokenManager: TokenManager = .shared
    ) {
        self.api = api
        self.tokenManager = tokenManager
    }
    
    func getTodayBreadCount(
        accessToken: String
    ) async throws -> BreadCount {
        
        guard
            let token = accessToken.isEmpty
                ? tokenManager.getAccessToken()
                : accessToken
        else {
            LoggerFactory.create(category: .data)
                .error("getTodayBreadCount: accessToken is nil")
            throw AuthError.invalidToken
        }
        
        let router = BbangRouter.getTodayBreadCount(accessToken: token)
        
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
