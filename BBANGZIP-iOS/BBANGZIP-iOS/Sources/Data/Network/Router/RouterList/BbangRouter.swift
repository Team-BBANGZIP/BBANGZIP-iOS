//
//  BbangRouter.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Alamofire

enum BbangRouter {
    // 여경
    case signIn(
        dto: SignInRequestDTO,
        providerToken: String
    )
    case refreshToken(refreshToken: String)
    case signUp(dto: SignUpRequestDTO)
    
    // 송희
    case addTodo(dto: TodoAddRequestDTO)
    case fetchTodos(params: TodoFetchRequestDTO)
    case addCategory(dto: CategoryAddRequestDTO)
    case editTodo(
        id: Int,
        dto: TodoEditRequestDTO
    )
    case deleteTodo(id: Int)
    case updateTodoStartTime(
        id: Int,
        dto: TodoStartTimeEditRequestDTO
    )
    case rescheduleTodo(
        id: Int,
        dto: TodoRescheduleRequestDTO
    )
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
        case .signUp:
            return "/api/v1/auth/signup"
            
        case .addTodo:
            return "/api/v1/todos"
        case .fetchTodos:
            return  "/api/v1/todos"
        case .addCategory:
            return "/api/v1/categories"
        case .editTodo(let id, _):
            return "/api/v1/todos/\(id)"
        case .deleteTodo(let id):
            return "/api/v1/todos/\(id)"
        case .updateTodoStartTime(let id, _):
            return "/api/v1/todos/\(id)/start-time"
        case .rescheduleTodo(let id, _):
            return "/api/v1/todos/\(id)/reschedule"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .refreshToken, .signUp:
            return .post
        case .addTodo, .addCategory:
            return .post
        case .fetchTodos:
            return .get
        case .editTodo, .updateTodoStartTime, .rescheduleTodo:
            return .patch
        case .deleteTodo:
            return .delete
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .signIn(_, let providerToken):
            return ["Provider-Token": providerToken]
            
        case .refreshToken(let refreshToken):
            return ["Authorization": "Bearer \(refreshToken)"]
            
        case .signUp:
            return ["Content-Type": "application/json"]
            
        case .addTodo,
                .fetchTodos,
                .addCategory,
                .editTodo,
                .deleteTodo,
                .updateTodoStartTime,
                .rescheduleTodo:
            return ["Content-Type": "application/json"]
        }
    }
    
    var parameters: [String: Sendable] {
        switch self {
        case .signIn(let dto, _):
            return dto.asDictionary()
        case .refreshToken:
            return [:]
        case .signUp(let dto):
            return dto.asDictionary()
            
        case .addTodo(let dto):
            return dto.asDictionary()
        case .fetchTodos(let params):
            return params.asDictionary()
        case .addCategory(let dto):
            return dto.asDictionary()
        case .editTodo(_, let dto):
            return dto.asDictionary()
        case .deleteTodo:
            return [:]
        case .updateTodoStartTime(_, let dto):
            return dto.asDictionary()
        case .rescheduleTodo(_, let dto):
            return dto.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .signIn, .signUp:
            return JSONEncoding.default
        case .refreshToken:
            return nil
            
        case .addTodo, .addCategory, .editTodo, .updateTodoStartTime, .rescheduleTodo:
            return JSONEncoding.default
        case .fetchTodos:
            return URLEncoding(destination: .queryString)
        case .deleteTodo:
            return nil
        }
    }
}
