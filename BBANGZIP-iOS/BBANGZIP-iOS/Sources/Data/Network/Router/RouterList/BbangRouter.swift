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
    case fetchCategories(params: CategoryFetchRequestDTO)
    case editCategory(
        id: Int,
        dto: CategoryEditRequestDTO
    )
    case deleteCategory(id: Int)
    case updateCategoryOrder(dto: CategoryOrderUpdateRequestDTO)
    case signOut
    case withdraw
    
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
    
    //유빈
    case getTodayBreadCount
    case getBreads
    case completeTimer(dto: TimerCompleteRequestDTO)
    case writeCommitmentMessage(dto: CommitmentMessageWriteRequestDTO)
    case completeTodo(id: Int, dto: TodoCompleteRequestDTO)
    case repeatTodo(id: Int, dto: TodoRepeatRequestDTO)
    case copyTodo(id: Int)
    case reorderTodo(dto: TodoReorderRequestDTO)
    case getProfile
    case updateProfile(dto: ProfileUpdateRequestDTO)
    
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
        case .signOut:
            return "/api/v1/auth/signout"
        case .withdraw:
            return "/api/v1/auth/withdraw"
        case .fetchCategories:
            return "/api/v1/categories"
        case .editCategory(let id, _),
                .deleteCategory(let id):
            return "/api/v1/categories/\(id)"
        case .updateCategoryOrder:
            return "/api/v1/categories/order"
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
        case .getTodayBreadCount:
            return "/api/v1/timers/today-count"
        case .getBreads:
            return "/api/v1/timers/breads"
        case .completeTimer:
            return "/api/v1/timers"
        case .writeCommitmentMessage:
            return "/api/v1/users/commitments"
        case .completeTodo(let id, _):
            return "/api/v1/todos/\(id)/completion"
        case .repeatTodo(let id, _):
            return "/api/v1/todos/\(id)/repeat"
        case .copyTodo(let id):
            return "/api/v1/todos/\(id)/copy"
        case .reorderTodo:
            return "/api/v1/todos/reorder"
        case .getProfile:
            return "/api/v1/users/profile"
        case .updateProfile:
            return "/api/v1/users/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .signIn, .refreshToken, .signUp:
            return .post
        case .addTodo, .addCategory, .completeTimer, .writeCommitmentMessage, .repeatTodo, .copyTodo:
            return .post
        case .fetchTodos, .fetchCategories, .getTodayBreadCount, .getBreads, .getProfile:
            return .get
        case .editTodo, .updateTodoStartTime, .rescheduleTodo, .editCategory, .updateCategoryOrder, .completeTodo, .reorderTodo, .updateProfile:
            return .patch
        case .deleteTodo, .deleteCategory, .signOut, .withdraw:
            return .delete
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .signIn(_, let providerToken):
            return ["Provider-Token": providerToken]
            
        case .refreshToken(let refreshToken):
            return ["Authorization": "Bearer \(refreshToken)"]
            
        case .signUp, .signOut, .withdraw:
            return ["Content-Type": "application/json"]
            
        case .addTodo,
                .fetchTodos,
                .addCategory,
                .editTodo,
                .deleteTodo,
                .updateTodoStartTime,
                .rescheduleTodo,
                .fetchCategories,
                .editCategory,
                .deleteCategory,
                .updateCategoryOrder,
                .getTodayBreadCount,
                .getBreads,
                .completeTimer,
                .writeCommitmentMessage,
                .completeTodo,
                .repeatTodo,
                .copyTodo,
                .reorderTodo,
                .getProfile,
                .updateProfile:
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
        case .signOut:
            return [:]
        case .withdraw:
            return [:]
        case .fetchCategories(let params):
            return params.asDictionary()
        case .editCategory(_, let dto):
            return dto.asDictionary()
        case .deleteCategory:
            return [:]
        case .updateCategoryOrder(let dto):
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
        case .getTodayBreadCount:
            return [:]
        case .getBreads:
            return [:]
        case .completeTimer(let dto):
            return dto.asDictionary()
        case .writeCommitmentMessage(let dto):
            return dto.asDictionary()
        case .completeTodo(_, let dto):
            return dto.asDictionary()
        case .repeatTodo(_, let dto):
            return dto.asDictionary()
        case .copyTodo(_):
            return [:]
        case .reorderTodo(let dto):
            return dto.asDictionary()
        case .getProfile:
            return [:]
        case .updateProfile(let dto):
            return dto.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        switch self {
        case .signIn, .signUp:
            return JSONEncoding.default
        case .refreshToken, .signOut, .withdraw:
            return nil
        case .addTodo, .addCategory, .editTodo, .updateTodoStartTime, .rescheduleTodo, .editCategory, .updateCategoryOrder, .completeTimer, .writeCommitmentMessage, .completeTodo, .repeatTodo, .copyTodo, .reorderTodo, .updateProfile:
            return JSONEncoding.default
        case .fetchTodos, .fetchCategories:
            return URLEncoding(destination: .queryString)
        case .deleteTodo, .deleteCategory, .getTodayBreadCount, .getBreads, .getProfile:
            return nil
        }
    }
}
