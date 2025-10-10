//
//  SignInRequestDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

struct SignInRequestDTO: Encodable, Sendable {
    let provider: AuthProvider
    let role: UserRole
    let deviceName: String
    let deviceType: DeviceType
    let osType: String
    let osVersion: String
    let appVersion: String
    
    enum AuthProvider: String, Encodable, Sendable {
        case kakao = "KAKAO"
        case apple = "APPLE"
    }
    
    enum UserRole: String, Encodable, Sendable {
        case user = "USER"
        case admin = "ADMIN"
    }
    
    enum DeviceType: String, Encodable, Sendable {
        case phone = "PHONE"
        case tablet = "TABLET"
        case desktop = "DESKTOP"
    }
}
