//
//  BreadCountResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

struct BreadCountResponseDTO: Decodable {
    let code: Int
    let data: BreadCountDataDTO
}

struct BreadCountDataDTO: Decodable {
    let todayBakedCount: Int
    
    func toDomain() -> BreadCount {
        return BreadCount(
            todayBakedCount: todayBakedCount
        )
    }
}
