//
//  ProfileResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/30/25.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let code: Int
    let data: ProfileDTO
    
    struct ProfileDTO: Decodable {
        let profileImageUrl: String?
        let nickname: String
        let commitmentMessage: String?
    }
}

extension ProfileResponseDTO.ProfileDTO {
    func toEntity() -> Profile {
        return Profile(
            profileImageUrl: profileImageUrl,
            nickname: nickname,
            commitmentMessage: commitmentMessage
        )
    }
}
