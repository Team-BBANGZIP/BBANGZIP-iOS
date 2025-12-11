//
//  SignOutResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 12/12/25.
//

import Foundation

struct SignOutResponseDTO: Decodable {
    let code: Int
}

extension SignOutResponseDTO {
    func toEntity() -> Bool {
        return code == 20000
    }
}
