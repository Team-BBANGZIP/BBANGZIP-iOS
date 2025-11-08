//
//  RouterError.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Foundation

enum RouterError: LocalizedError {
    case invalidURL
    case encoding
    case server(message: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
        case .encoding:
            return "Encoding 과정에서 오류가 발생했습니다."
        case .server(let message):
            return message
        }
    }
}
