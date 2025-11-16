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

// MARK: - RequestRetrier

extension AuthInterceptor {
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        // 0) 이미 한 번 retry 했다면 더 이상 시도하지 않음 (무한 루프 방지)
        if request.retryCount >= 1 {
            return completion(.doNotRetry)
        }

        // 1) statusCode가 401이 아니면 그냥 실패
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401
        else {
            return completion(.doNotRetry)
        }
        
        // 2) 로그인 / 재발급 요청이 401이면 더 이상 할 수 있는 게 없음
        if let urlString = request.request?.url?.absoluteString,
           urlString.contains("signin") || urlString.contains("re-issue") {
            return completion(.doNotRetry)
        }
        
        // 3) refreshToken이 없으면 재발급 불가
        guard let refreshToken = tokenManager.getRefreshToken() else {
            return completion(.doNotRetry)
        }
        
        let router = BbangRouter.refreshToken(refreshToken: refreshToken)
        
        // 4) refresh 토큰 요청
        session.request(router)
            .validate()
            .responseDecodable(of: TokenRefreshResponseDTO.self) { [weak self] response in
                guard let self else {
                    return completion(.doNotRetry)
                }
                
                switch response.result {
                case .success(let dto):
                    // DTO → AuthToken 변환
                    let authToken = dto.toEntity()
                    self.tokenManager.saveAccessToken(authToken.accessToken)
                    self.tokenManager.saveRefreshToken(authToken.refreshToken)
                    
                    // 새 토큰 저장 후 원래 요청 1번만 재시도
                    completion(.retry)
                    
                case .failure:
                    // refresh 실패 → 그대로 실패
                    completion(.doNotRetry)
                }
            }
    }
}
