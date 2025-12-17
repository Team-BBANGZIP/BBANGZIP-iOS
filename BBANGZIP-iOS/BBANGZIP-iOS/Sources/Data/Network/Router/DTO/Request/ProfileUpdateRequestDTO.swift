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
    
    enum CodingKeys: String, CodingKey {
        case profileImageKey
        case nickname
        case commitmentMessage
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(profileImageKey, forKey: .profileImageKey)
        try container.encodeIfPresent(nickname, forKey: .nickname)
        try container.encodeIfPresent(commitmentMessage, forKey: .commitmentMessage)
    }
    
    func asDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        if let profileImageKey = profileImageKey {
            dict["profileImageKey"] = profileImageKey
        }
        if let nickname = nickname {
            dict["nickname"] = nickname
        }
        if let commitmentMessage = commitmentMessage {
            dict["commitmentMessage"] = commitmentMessage
        }
        
        return dict
    }
}
