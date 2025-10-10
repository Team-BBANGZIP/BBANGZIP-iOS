//
//  BbangRouter.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Alamofire

enum BbangRouter {
    //여경
    case signIn(dto: SignInRequestDTO, providerToken: String)
    case refreshToken(refreshToken: String)
    
    // TODO: 추가 API들은 여기에 case로 추가
}

extension BbangRouter: Router {
    var baseURL: String {
        Environment.baseURL
    }
    
    var path: String {
        switch self {
        case .signIn:
            return "/api/v1/auth/signin"
        case .refreshToken:
            return "/api/v1/auth/re-issue"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .refreshToken:
            return .post
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .signIn(_, let providerToken):
            return ["Provider-Token": providerToken]
            
        case .refreshToken(let refreshToken):
            return ["Authorization": "Bearer \(refreshToken)"]
        }
    }
    
    var parameters: [String: Sendable] {
        switch self {
        case .signIn(let dto, _):
            return dto.asDictionary()
        case .refreshToken:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .signIn:
            return JSONEncoding.default
        case .refreshToken:
            return nil
        }
    }
}
