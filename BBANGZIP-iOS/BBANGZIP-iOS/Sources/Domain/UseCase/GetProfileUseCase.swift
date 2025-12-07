//
//  GetProfileUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/30/25.
//

import Foundation

protocol GetProfileUseCase: Sendable {
    func getProfile() async throws -> Profile
}

final class GetProfileUseCaseImpl: GetProfileUseCase {
    private let repository: ProfileRepository
    
    init(repository: ProfileRepository) {
        self.repository = repository
    }
    
    func getProfile() async throws -> Profile {
        return try await repository.getProfile()
    }
}
