//
//  SignUpUseCase.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/08/25.
//

import Foundation

protocol SignUpUseCase: Sendable {
    func execute(
        nickname: String,
        profileImageKey: Int
    ) async throws -> SignUp
}

final class SignUpUseCaseImpl: SignUpUseCase {
    private let repository: SignUpRepository
    
    init(repository: SignUpRepository = SignUpRepositoryImpl()) {
        self.repository = repository
    }
    
    func execute(nickname: String, profileImageKey: Int) async throws -> SignUp {
        return try await repository.signUp(
            nickname: nickname,
            profileImageKey: profileImageKey
        )
    }
}
