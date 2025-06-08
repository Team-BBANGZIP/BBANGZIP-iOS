//
//  TimerCase.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

enum TimerCase {
    case halfHour
    case oneHour
    
    var totalSeconds: Int {
        switch self {
        case .halfHour:
            return 30 * 60
        case .oneHour:
            return 60 * 60
        }
    }
}
