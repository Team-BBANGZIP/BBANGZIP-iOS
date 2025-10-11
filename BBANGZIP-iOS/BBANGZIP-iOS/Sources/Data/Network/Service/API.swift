//
//  API.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Foundation
import Alamofire

final class API: Sendable {
    private let session: Session
    
    init(
        session: Session = Session(
            interceptor: AuthInterceptor(),
            eventMonitors: [Monitor()]
        )
    ) {
        self.session = session
        LoggerFactory.create(category: .lifeCycle)
            .debug("\(String(describing: self)), \(String(describing: #function))")
    }
    
    deinit {
        LoggerFactory.create(category: .lifeCycle)
            .debug("\(String(describing: self)), \(String(describing: #function))")
    }
    
    func request<T: Router, U: Decodable & Sendable>(api: T) async throws -> U {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(api)
                .validate()
                .responseDecodable(of: U.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
