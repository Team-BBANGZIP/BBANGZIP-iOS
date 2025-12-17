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
    let nickname: String
    let commitmentMessage: String?
    
    func toEntity() -> Profile {
        var extractedKey: Int?
        
        if let url = profileImageUrl {
            let components = url.components(separatedBy: "Profile_")
            if components.count > 1,
               let keyString = components.last?.components(separatedBy: ".").first,
               let key = Int(keyString) {
                extractedKey = key
            }
            
            if extractedKey == nil {
                let urlComponents = url.components(separatedBy: "/")
                if let lastComponent = urlComponents.last,
                   let keyString = lastComponent.components(separatedBy: ".").first,
                   let key = Int(keyString) {
                    extractedKey = key
                }
            }
        }
        
        return Profile(
            profileImageUrl: profileImageUrl,
            profileImageKey: extractedKey,
            nickname: nickname,
            commitmentMessage: commitmentMessage
        )
    }
}
