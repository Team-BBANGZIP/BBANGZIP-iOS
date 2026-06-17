//
//  TimerCompleteUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/5/25.
//

import Foundation

protocol TimerCompleteUseCase: Sendable {
    func execute(
        targetDate: String,
        count: Int
    ) async throws -> TimerCompleteCount
}

final class DefaultTimerCompleteUseCase: TimerCompleteUseCase {
    private let repository: TimerCompleteRepositoryProtocol
    
    init(repository: TimerCompleteRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(
        targetDate: String,
        count: Int
    ) async throws -> TimerCompleteCount {
        let request = TimerCompleteRequestDTO(
            targetDate: targetDate,
            count: count
        )
        return try await repository.completeTimer(request: request)
    }
}
