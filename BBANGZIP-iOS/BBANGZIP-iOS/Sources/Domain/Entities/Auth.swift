//
//  Auth.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

struct AuthToken: Sendable {
    let accessToken: String
    let refreshToken: String
}

struct SignInResult: Sendable {
    let authToken: AuthToken
    let isSignUpComplete: Bool
}

enum AuthProvider: Sendable {
    case kakao
    case apple
}

enum UserRole: Sendable {
    case user
    case admin
}
