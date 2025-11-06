//
//  TimerCompleteRepository.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/5/25.
//

import Foundation

protocol TimerCompleteRepositoryProtocol: Sendable {
    func completeTimer(request: TimerCompleteRequestDTO) async throws -> TimerCompleteCount
}

final class TimerCompleteRepository: TimerCompleteRepositoryProtocol {
    private let api: API
    private let tokenManager: TokenManager
    
    init(
        api: API = API(),
        tokenManager: TokenManager = .shared
    ) {
        self.api = api
        self.tokenManager = tokenManager
    }
    
    func completeTimer(request: TimerCompleteRequestDTO) async throws -> TimerCompleteCount {
        guard let accessToken = tokenManager.getAccessToken() else {
            LoggerFactory.create(category: .data)
                .error("CompleteTimer Error: AccessToken is nil")
            throw AuthError.invalidToken
        }
        
        let router = BbangRouter.completeTimer(dto: request, accessToken: accessToken)
        
        do {
            let response: TimerCompleteResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("completeTimer: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("completeTimer: \(error.localizedDescription)")
            
            throw error
        }
    }
}
