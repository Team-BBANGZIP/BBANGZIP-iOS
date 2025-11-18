//
//  CommitmentMessageWriteRepositoryProtocol.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/7/25.
//

import Foundation

protocol WriteCommitmentMessageRepositoryProtocol: Sendable {
    func writeCommitmentMessage(request: CommitmentMessageWriteRequestDTO) async throws -> CommitmentMessage
}

final class WriteCommitmentMessageRepository: WriteCommitmentMessageRepositoryProtocol {
    private let api: API
    
    init(
        api: API = .shared
    ) {
        self.api = api
    }
    
    func writeCommitmentMessage(request: CommitmentMessageWriteRequestDTO) async throws -> CommitmentMessage {
        let router = BbangRouter.writeCommitmentMessage(dto: request)
        
        do {
            let response: CommitmentMessageWriteResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("writeCommitmentMessage: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("writeCommitmentMessage: \(error.localizedDescription)")
            
            throw error
        }
    }
}
