//
//  TimerCompleteResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/5/25.
//

import Foundation

struct TimerCompleteResponseDTO: Decodable {
    let code: Int
    let data: TimerCountDTO
    
    struct TimerCountDTO: Decodable {
        let count: Int
    }
}

extension TimerCompleteResponseDTO.TimerCountDTO {
    func toEntity() -> TimerCompleteCount {
        return TimerCompleteCount(
            count: count
        )
    }
}
