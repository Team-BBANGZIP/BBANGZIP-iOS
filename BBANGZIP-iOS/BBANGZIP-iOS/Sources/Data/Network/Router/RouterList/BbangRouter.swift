//
//  BbangRouter.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Alamofire

enum BbangRouter {
    case signIn(
        dto: SignInRequestDTO,
        providerToken: String
    )
    case refreshToken(refreshToken: String)
    case signUp(
        dto: SignUpRequestDTO,
        accessToken: String
    )
}

extension BbangRouter: Router {
    var baseURL: String {
        ConfigManager.baseURL
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/api/v1/auth/signin"
        case .refreshToken:
            return "/api/v1/auth/re-issue"
        case .signUp:
            return "/api/v1/auth/signup"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .refreshToken, .signUp:
            return .post
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .signIn(_, let providerToken):
            return ["Provider-Token": providerToken]
            
        case .refreshToken(let refreshToken):
            return ["Authorization": "Bearer \(refreshToken)"]
            
        case .signUp(
            _,
            let accessToken
        ):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
    
    var parameters: [String: Sendable] {
        switch self {
        case .signIn(let dto, _):
            return dto.asDictionary()
        case .refreshToken:
            return [:]
        case .signUp(let dto, _):
            return dto.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .signIn, .signUp:
            return JSONEncoding.default
        case .refreshToken:
            return nil
        }
    }
}
