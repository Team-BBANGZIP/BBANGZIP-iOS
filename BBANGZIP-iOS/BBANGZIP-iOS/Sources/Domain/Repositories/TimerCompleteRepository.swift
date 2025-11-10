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
    
    init(
        api: API = API()
    ) {
        self.api = api
    }
    
    func completeTimer(request: TimerCompleteRequestDTO) async throws -> TimerCompleteCount {
        let router = BbangRouter.completeTimer(dto: request)
        
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
