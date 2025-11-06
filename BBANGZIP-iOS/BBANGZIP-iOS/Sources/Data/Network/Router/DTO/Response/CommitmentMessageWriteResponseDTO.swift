//
//  CommitmentMessageWriteResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/7/25.
//

import Foundation

struct CommitmentMessageWriteResponseDTO: Decodable {
    let code: Int
    let data: CommitmentMessageDTO
    
    struct CommitmentMessageDTO: Decodable {
        let commitmentMessage: String
    }
}

extension CommitmentMessageWriteResponseDTO.CommitmentMessageDTO {
    func toEntity() -> CommitmentMessage {
        return CommitmentMessage(
            commitmentMessage: commitmentMessage
        )
    }
}
