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
        nickname: String,
        currentProfileImageKey: Int
    ) async throws -> Profile
    
    func updateCommitmentMessage(
        commitmentMessage: String,
        currentProfileImageKey: Int
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
            profileImageKey: profileImageKey,
            nickname: nil,
            commitmentMessage: nil
        )
        
        return try await repository.updateProfile(request: request)
    }
    
    func updateNickname(
        nickname: String,
        currentProfileImageKey: Int
    ) async throws -> Profile {
        let request = ProfileUpdateRequestDTO(
            profileImageKey: currentProfileImageKey,
            nickname: nickname,
            commitmentMessage: nil
        )
        
        return try await repository.updateProfile(request: request)
    }
    
    func updateCommitmentMessage(
        commitmentMessage: String,
        currentProfileImageKey: Int
    ) async throws -> Profile {
        let request = ProfileUpdateRequestDTO(
            profileImageKey: currentProfileImageKey,
            nickname: nil,
            commitmentMessage: commitmentMessage
        )
        
        return try await repository.updateProfile(request: request)
    }
}
