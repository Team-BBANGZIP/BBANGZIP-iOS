//
//  SignInUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

protocol SignInUseCase: Sendable {
    func execute(
        provider: AuthProvider,
        providerToken: String,
        role: UserRole
    ) async throws -> SignInResult
}

final class SignInUseCaseImpl: SignInUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(
        provider: AuthProvider,
        providerToken: String,
        role: UserRole = .user
    ) async throws -> SignInResult {
        return try await repository.signIn(
            provider: provider,
            providerToken: providerToken,
            role: role
        )
    }
}
