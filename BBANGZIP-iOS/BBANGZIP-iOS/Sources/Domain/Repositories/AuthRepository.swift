//
//  AuthRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

protocol AuthRepository: Sendable {
    func signIn(
        provider: AuthProvider,
        providerToken: String,
        role: UserRole
    ) async throws -> SignInResult
    
    func refreshToken() async throws -> AuthToken
    func signOut() async throws -> Bool
    func withdraw() async throws -> Bool
}

final class AuthRepositoryImpl: AuthRepository {
    private let api: API
    private let tokenManager = TokenManager.shared
    
    init(api: API = .shared) {
        self.api = api
    }
    
    @MainActor
    func signIn(
        provider: AuthProvider,
        providerToken: String,
        role: UserRole
    ) async throws -> SignInResult {
        let requestDTO = SignInRequestDTO(
            provider: provider.toDTO(),
            role: role.toDTO(),
            deviceName: DeviceInfoProvider.getDeviceName(),
            deviceType: DeviceInfoProvider.getDeviceType(),
            osType: DeviceInfoProvider.getOSType(),
            osVersion: DeviceInfoProvider.getOSVersion(),
            appVersion: DeviceInfoProvider.getAppVersion()
        )
        
        let router = BbangRouter.signIn(
            dto: requestDTO,
            providerToken: providerToken
        )
        
        do {
            let response: SignInResponseDTO = try await api.request(api: router)
            
            tokenManager.saveTokens(
                accessToken: response.data.accessToken,
                refreshToken: response.data.refreshToken
            )
            
            return response.toEntity()
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("SignIn Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func refreshToken() async throws -> AuthToken {
        guard let refreshToken = tokenManager.getRefreshToken() else {
            throw AuthError.noRefreshToken
        }
        
        let router = BbangRouter.refreshToken(refreshToken: refreshToken)
        
        do {
            let response: TokenRefreshResponseDTO = try await api.request(api: router)
            
            tokenManager.saveTokens(
                accessToken: response.data.accessToken,
                refreshToken: response.data.refreshToken
            )
            
            return response.toEntity()
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("Token Refresh Error: \(error.localizedDescription)")
            
            tokenManager.clearTokens()
            throw error
        }
    }
    
    func signOut() async throws -> Bool {
        let router = BbangRouter.signOut
        
        do {
            let response: SignOutResponseDTO = try await api.request(api: router)
            
            LoggerFactory.create(category: .data)
                .info("SignOut Success")
            
            return response.code == 20000
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("SignOut Error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func withdraw() async throws -> Bool {
        let router = BbangRouter.withdraw
        
        do {
            let response: WithdrawResponseDTO = try await api.request(api: router)
            
            LoggerFactory.create(category: .data)
                .info("Withdraw Success")
            
            return response.code == 20000
            
        } catch {
            LoggerFactory.create(category: .data)
                .error("Withdraw Error: \(error.localizedDescription)")
            throw error
        }
    }
}

enum AuthError: LocalizedError {
    case noRefreshToken
    case tokenExpired
    case invalidToken
    
    var errorDescription: String? {
        switch self {
        case .noRefreshToken:
            return "Refresh Token이 없습니다."
        case .tokenExpired:
            return "토큰이 만료되었습니다."
        case .invalidToken:
            return "유효하지 않은 토큰입니다."
        }
    }
}
