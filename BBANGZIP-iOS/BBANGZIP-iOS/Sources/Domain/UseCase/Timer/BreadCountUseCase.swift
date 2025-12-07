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
    
    init(repository: BreadCountRepository) {
        self.repository = repository
    }
    
    func getTodayBreadCount() async throws -> Int {
        
        return try await repository.getTodayBreadCount().todayBakedCount
    }
}
