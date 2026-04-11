//
//  ProfileResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/30/25.
//

import Foundation

struct ProfileResponseDTO: Decodable {
    let code: Int
    let data: ProfileDataDTO
}

struct ProfileDataDTO: Decodable {
    let profileImageUrl: String?
    let profileImageKey: Int?
    let nickname: String
    let commitmentMessage: String?

    func toEntity() -> Profile {
        return Profile(
            profileImageUrl: profileImageUrl,
            profileImageKey: profileImageKey,
            nickname: nickname,
            commitmentMessage: commitmentMessage
        )
    }
}
