//
//  BreadCountUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

protocol BreadCountUseCase: Sendable {
    func getTodayBreadCount() async throws -> Int
}

final class BreadCountUseCaseImpl: BreadCountUseCase {
    private let repository: BreadCountRepository
    private let tokenManager: TokenManager
    
    init(repository: BreadCountRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func getTodayBreadCount() async throws -> Int {
        
        guard let accessToken = tokenManager.getAccessToken() else {
            LoggerFactory.create(category: .data)
                .error("getTodayBreadCount Error: AccessToken is nil")
            
            throw AuthError.invalidToken
        }
        
        return try await repository.getTodayBreadCount(accessToken: accessToken).todayBakedCount
    }
}
