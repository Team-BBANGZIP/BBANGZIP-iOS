//
//  TestRouter.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Alamofire

enum TestRouter {
    case test(dto: TestRequestDTO)
}

extension TestRouter: Router {
    var baseURL: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        return "/comments"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: [String : String] {
        return [
            "Content-Type": "application/json"
        ]
    }
    
    var parameters: [String : Sendable] {
        switch self {
        case .test(let dto):
            return dto.asDictionary()
        }
    }
    
    var encoding: ParameterEncoding? {
        return URLEncoding.default
    }
}
