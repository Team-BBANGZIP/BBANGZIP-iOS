//
//  TokenManager.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

final class TokenManager: Sendable {
    static let shared = TokenManager()
    
    private let keychain = KeychainManager.shared
    
    private init() {}
    
    func saveAccessToken(_ token: String) {
        keychain.save(token, forKey: .accessToken)
    }
    
    func getAccessToken() -> String? {
        return keychain.load(forKey: .accessToken)
    }
    
    func saveRefreshToken(_ token: String) {
        keychain.save(token, forKey: .refreshToken)
    }
    
    func getRefreshToken() -> String? {
        return keychain.load(forKey: .refreshToken)
    }
    
    func saveTokens(accessToken: String, refreshToken: String) {
        saveAccessToken(accessToken)
        saveRefreshToken(refreshToken)
    }
    
    func clearTokens() {
        keychain.delete(forKey: .accessToken)
        keychain.delete(forKey: .refreshToken)
    }
    
    func hasValidTokens() -> Bool {
        return getAccessToken() != nil && getRefreshToken() != nil
    }
}
