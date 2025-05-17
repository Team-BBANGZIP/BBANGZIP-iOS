//
//  LoggerFactory.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import OSLog

final class LoggerFactory {
    enum LoggerCategory: String {
        case presentation
        case domain
        case data
        case lifeCycle
        case etc
    }
    
    static func create(category: LoggerCategory) -> Logger {
        return Logger(
            subsystem: String.subsystem,
            category: category.rawValue
        )
    }
}

extension String {
    static let subsystem = "BBANGZIP-iOS.app"
}
