//
//  GetBreadsRepository.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/3/25.
//

import Foundation

protocol GetBreadsRepositoryProtocol: Sendable {
    func getBreads(
        accessToken: String
    ) async throws -> BreadList
}

final class GetBreadsRepository: GetBreadsRepositoryProtocol {
    private let api: API
    private let tokenManager: TokenManager

    init(
        api: API = API(),
        tokenManager: TokenManager = .shared
    ) {
        self.api = api
        self.tokenManager = tokenManager
    }
    
    func getBreads(
        accessToken: String
    ) async throws -> BreadList {
        
        guard
            let token = accessToken.isEmpty
                ? tokenManager.getAccessToken()
                : accessToken
        else {
            LoggerFactory.create(category: .data)
                .error("getBreads: accessToken is nil")
            throw AuthError.invalidToken
        }
        
        let router = BbangRouter.getBreads(accessToken: token)
        
        do {
            let response: BreadsResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("getBreads: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("getBreads: \(error.localizedDescription)")
            
            throw error
        }
    }
}
