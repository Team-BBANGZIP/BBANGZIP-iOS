//
//  AuthInterceptor.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    private let tokenManager = TokenManager.shared
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        
        guard let urlString = request.url?.absoluteString,
              !urlString.contains("signin"),
              !urlString.contains("re-issue") else {
            return completion(.success(request))
        }
        
        if let accessToken = tokenManager.getAccessToken() {
            request.headers.add(.authorization(bearerToken: accessToken))
        }
        
        completion(.success(request))
    }
}
