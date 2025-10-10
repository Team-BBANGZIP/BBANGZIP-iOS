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

