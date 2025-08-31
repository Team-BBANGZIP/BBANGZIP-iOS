//
//  BreadCount.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

struct BreadCount {
    let todayBakedCount: Int
}

extension BreadCount {
    init(from dto: BreadCountResponseDTO) {
        self.todayBakedCount = dto.data.todayBakedCount
    }
}
