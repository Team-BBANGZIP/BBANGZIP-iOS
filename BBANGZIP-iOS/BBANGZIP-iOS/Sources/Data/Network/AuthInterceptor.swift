//
//  AuthInterceptor.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {
    private let tokenManager = TokenManager.shared

    private let lock = NSLock()
    private var isRefreshing = false
    private var pendingCompletions: [@Sendable (RetryResult) -> Void] = []
}

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
        completion: @escaping @Sendable (RetryResult) -> Void
    ) {
        guard request.retryCount < 1 else {
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
            handleAuthenticationFailure()
            return completion(.doNotRetry)
        }

        lock.lock()
        pendingCompletions.append(completion)
        if isRefreshing {
            lock.unlock()
            return
        }
        isRefreshing = true
        lock.unlock()

        refreshTokens(refreshToken: refreshToken, session: session)
    }

    private func refreshTokens(refreshToken: String, session: Session) {
        let router = BbangRouter.refreshToken(refreshToken: refreshToken)

        session.request(router)
            .validate()
            .responseDecodable(of: TokenRefreshResponseDTO.self) { [weak self] response in
                guard let self else { return }

                switch response.result {
                case .success(let dto):
                    let authToken = dto.toEntity()
                    self.tokenManager.saveAccessToken(authToken.accessToken)
                    self.tokenManager.saveRefreshToken(authToken.refreshToken)
                    self.completePending(with: .retry)

                case .failure(let error):
                    print("❌ Token refresh failed: \(error)")
                    self.handleAuthenticationFailure()
                    self.completePending(with: .doNotRetry)
                }
            }
    }

    private func completePending(with result: RetryResult) {
        lock.lock()
        let completions = pendingCompletions
        pendingCompletions.removeAll()
        isRefreshing = false
        lock.unlock()

        completions.forEach { $0(result) }
    }

    private func handleAuthenticationFailure() {
        tokenManager.clearTokens()

        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: NSNotification.Name("AuthenticationFailed"),
                object: nil
            )
        }
    }
}
