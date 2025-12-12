//
//  SignOutUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 12/12/25.
//

import Foundation

protocol SignOutUseCase: Sendable {
    func execute() async throws -> Bool
}

final class SignOutUseCaseImpl: SignOutUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> Bool {
        return try await repository.signOut()
    }
}
