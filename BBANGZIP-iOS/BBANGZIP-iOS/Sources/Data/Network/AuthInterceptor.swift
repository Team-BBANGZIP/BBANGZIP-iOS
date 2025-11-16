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
}

// MARK: - RequestAdapter

extension AuthInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        
        guard let urlString = request.url?.absoluteString,
              !urlString.contains("signin"),
              !urlString.contains("re-issue") else {
            // 로그인 / 토큰 재발급 API에는 Authorization 헤더 안 붙임
            return completion(.success(request))
        }
        
        if let accessToken = tokenManager.getAccessToken() {
            request.headers.add(.authorization(bearerToken: accessToken))
        }
        
        completion(.success(request))
    }
}

extension AuthInterceptor {
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if request.retryCount >= 1 {
            return completion(.doNotRetry)
        }

        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401
        else {
            return completion(.doNotRetry)
        }
        
        if let urlString = request.request?.url?.absoluteString,
           urlString.contains("signin") || urlString.contains("re-issue") {
            return completion(.doNotRetry)
        }
        
        guard let refreshToken = tokenManager.getRefreshToken() else {
            return completion(.doNotRetry)
        }
        
        let router = BbangRouter.refreshToken(refreshToken: refreshToken)
        
        session.request(router)
            .validate()
            .responseDecodable(of: TokenRefreshResponseDTO.self) { [weak self] response in
                guard let self else {
                    return completion(.doNotRetry)
                }
                
                switch response.result {
                case .success(let dto):
                    let authToken = dto.toEntity()
                    self.tokenManager.saveAccessToken(authToken.accessToken)
                    self.tokenManager.saveRefreshToken(authToken.refreshToken)
                    
                    completion(.retry)
                    
                case .failure:
                    completion(.doNotRetry)
                }
            }
    }
}
