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
    
    func getTodayBreadCount() async throws -> BreadCount {
        // TODO: API 연결 전까지 임시 더미 데이터 사용
        let dummyResponse = BreadCountResponseDTO(
            code: "success",
            data: BreadCountDataDTO(todayBakedCount: 6)
        )
        
        return BreadCount(from: dummyResponse)
    }
}
