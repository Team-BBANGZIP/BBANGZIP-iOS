//
//  SignInResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

struct SignInResponseDTO: Decodable, Sendable {
    let code: Int
    let data: SignInData
    
    struct SignInData: Decodable, Sendable {
        let accessToken: String
        let refreshToken: String
        let isSignUpComplete: Bool
    }
}

struct TokenRefreshResponseDTO: Decodable, Sendable {
    let code: Int
    let data: TokenData
    
    struct TokenData: Decodable, Sendable {
        let accessToken: String
        let refreshToken: String
    }
}

extension SignInResponseDTO {
    func toEntity() -> SignInResult {
        return SignInResult(
            authToken: AuthToken(
                accessToken: data.accessToken,
                refreshToken: data.refreshToken
            ),
            isSignUpComplete: data.isSignUpComplete
        )
    }
}

extension TokenRefreshResponseDTO {
    func toEntity() -> AuthToken {
        return AuthToken(
            accessToken: data.accessToken,
            refreshToken: data.refreshToken
        )
    }
}
