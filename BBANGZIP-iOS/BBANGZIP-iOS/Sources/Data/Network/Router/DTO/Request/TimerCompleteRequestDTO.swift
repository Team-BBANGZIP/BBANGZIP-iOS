//
//  TimerCompleteRequestDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/4/25.
//

import Foundation

struct TimerCompleteRequestDTO: Encodable {
    let targetDate: String
    let count: Int
}
