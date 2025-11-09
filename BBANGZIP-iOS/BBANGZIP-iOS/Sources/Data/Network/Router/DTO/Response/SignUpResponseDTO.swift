//
//  SignUpResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/8/25.
//

import Foundation

struct SignUpResponseDTO: Decodable {
    let code: Int
    
    func toEntity() -> SignUp {
        return SignUp(isSuccess: code == 20000)
    }
}
