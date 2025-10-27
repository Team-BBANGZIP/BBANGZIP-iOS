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
    
    //송희
    case addTodo(dto: TodoAddRequestDTO, accessToken: String)
    case fetchTodos(params: TodoFetchRequestDTO, accessToken: String)
    case addCategory(dto: CategoryAddRequestDTO, accessToken: String)
    
    // TODO: 추가 API들은 여기에 case로 추가
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
        case .addTodo:
            return "/api/v1/todos"
        case .fetchTodos:
            return "/api/v1/todos"
        case .addCategory:
            return "/api/v1/categories"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .refreshToken, .addTodo, .addCategory:
            return .post
        case .fetchTodos:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .signIn(_, let providerToken):
            return ["Provider-Token": providerToken]
            
        case .refreshToken(let refreshToken):
            return ["Authorization": "Bearer \(refreshToken)"]
            
        case .addTodo(_, let accessToken), .fetchTodos(_, let accessToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .addCategory(_, let accessToken):
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
        case .addTodo(let dto, _):
            return dto.asDictionary()
        case .fetchTodos(let params, _):
            return params.asDictionary()
        case .addCategory(let dto, _):
            return dto.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .signIn, .addTodo, .addCategory:
            return JSONEncoding.default
        case .fetchTodos:
            return URLEncoding(destination: .queryString)
        case .refreshToken:
            return nil
        }
    }
}
