//
//  UpdateProfileUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 12/7/25.
//

import Foundation

protocol UpdateProfileUseCase: Sendable {
    func updateProfileImage(
        profileImageKey: Int
    ) async throws -> Profile
    
    func updateNickname(
        nickname: String
    ) async throws -> Profile
    func updateCommitmentMessage(
        commitmentMessage: String
    ) async throws -> Profile
}

final class DefaultUpdateProfileUseCase: UpdateProfileUseCase {
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    func updateProfileImage(
        profileImageKey: Int
    ) async throws -> Profile {
        let request = ProfileUpdateRequestDTO(
            profileImageKey: profileImageKey
        )
        
        return try await repository.updateProfile(request: request)
    }
    
    func updateNickname(
        nickname: String
    ) async throws -> Profile {
        let request = ProfileUpdateRequestDTO(
            nickname: nickname
        )
        
        return try await repository.updateProfile(request: request)
    }
    
    func updateCommitmentMessage(
        commitmentMessage: String
    ) async throws -> Profile {
        let request = ProfileUpdateRequestDTO(
            commitmentMessage: commitmentMessage
        )
        
        return try await repository.updateProfile(request: request)
    }
}
