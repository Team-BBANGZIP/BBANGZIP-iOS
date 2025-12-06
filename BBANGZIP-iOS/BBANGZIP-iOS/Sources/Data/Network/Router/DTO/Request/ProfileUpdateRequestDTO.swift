//
//  ProfileUpdateRequestDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 12/7/25.
//

import Foundation

struct ProfileUpdateRequestDTO: Encodable {
    let profileImageKey: Int?
    let nickname: String?
    let commitmentMessage: String?
    
    init(
        profileImageKey: Int? = nil,
        nickname: String? = nil,
        commitmentMessage: String? = nil
    ) {
        self.profileImageKey = profileImageKey
        self.nickname = nickname
        self.commitmentMessage = commitmentMessage
    }

}
