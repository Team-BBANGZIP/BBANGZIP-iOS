//
//  GetBreadsUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/3/25.
//

import Foundation

protocol GetBreadsUseCaseProtocol: Sendable {
    func execute() async throws -> BreadList
}

final class GetBreadsUseCase: GetBreadsUseCaseProtocol {
    private let repository: GetBreadsRepository
    private let tokenManager: TokenManager
    
    init(repository: GetBreadsRepository, tokenManager: TokenManager = .shared) {
        self.repository = repository
        self.tokenManager = tokenManager
    }
    
    func execute() async throws -> BreadList {
        guard let accessToken = tokenManager.getAccessToken() else {
            LoggerFactory.create(category: .data)
                .error("getBreads Error: AccessToken is nil")
            throw AuthError.invalidToken
        }
        return try await repository.getBreads(accessToken: accessToken)
    }
}
