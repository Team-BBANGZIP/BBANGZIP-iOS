//
//  WithdrawResponseDTO.swift
//  BBANGZIP
//
//  Created by 송여경 on 12/12/25.
//

import Foundation

struct WithdrawResponseDTO: Decodable {
    let code: Int
}

extension WithdrawResponseDTO {
    func toEntity() -> Bool {
        return code == 20000
    }
}
