//
//  CommitmentMessageWriteUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/7/25.
//

import Foundation

protocol WriteCommitmentMessageUseCase: Sendable {
    func execute(commitmentMessage: String) async throws -> CommitmentMessage
}

final class DefaultWriteCommitmentMessageUseCase: WriteCommitmentMessageUseCase {
    private let repository: WriteCommitmentMessageRepository
    
    init(repository: WriteCommitmentMessageRepository) {
        self.repository = repository
    }
    
    func execute(
        commitmentMessage: String
    ) async throws -> CommitmentMessage {
        let request = CommitmentMessageWriteRequestDTO(
            commitmentMessage: commitmentMessage
        )
        return try await repository.writeCommitmentMessage(request: request)
    }
}
