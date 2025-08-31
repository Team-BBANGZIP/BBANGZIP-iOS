//
//  BreadCountEntity.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

struct BreadCountEntity {
    let todayBakedCount: Int
}

extension BreadCountEntity {
    init(from dto: BreadCountResponseDTO) {
        self.todayBakedCount = dto.data.todayBakedCount
    }
}
