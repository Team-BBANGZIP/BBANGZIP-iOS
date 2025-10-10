//
//  KeychainManager.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation
import Security

final class KeychainManager: Sendable {
    static let shared = KeychainManager()
    
    private let service = ConfigManager.baseURL
    
    private init() {}
    
    func save(_ value: String, forKey key: KeychainKey) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            LoggerFactory.create(category: .data)
                .error("Keychain Save Error: \(status)")
        }
    }
    
    func load(forKey key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(
                data: data,
                encoding: .utf8
              ) else {
            return nil
        }
        
        return value
    }
    
    func delete(forKey key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key.rawValue
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func deleteAll() {
        for key in KeychainKey.allCases {
            delete(forKey: key)
        }
    }
}

enum KeychainKey: String, CaseIterable {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}
