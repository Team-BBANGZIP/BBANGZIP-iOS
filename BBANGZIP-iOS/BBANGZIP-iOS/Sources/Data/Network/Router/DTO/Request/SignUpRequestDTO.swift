//
//  SignUpRequestDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/8/25.
//

import Foundation

struct SignUpRequestDTO: Encodable {
    let nickname: String
    let profileImageKey: Int
    
    func asDictionary() -> [String: Any] {
        return [
            "nickname": nickname,
            "profileImageKey": profileImageKey
        ]
    }
}
