//
//  BreadsResponseDTO.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/1/25.
//

struct BreadsResponseDTO: Decodable {
    let code: Int
    let data: BreadListDataDTO
    
    struct BreadListDataDTO: Decodable {
        let totalCount: Int
        let breadList: [BreadDTO]
    }
    
    struct BreadDTO: Decodable {
        let breadId: Int
        let breadName: String
        let isUnlocked: Bool
        let requiredCount: Int
        let imageUrl: String
    }
}

extension BreadsResponseDTO.BreadListDataDTO {
    func toEntity() -> BreadList {
        BreadList(
            totalCount: totalCount,
            breadList: breadList.map { $0.toEntity() }
        )
    }
}

extension BreadsResponseDTO.BreadDTO {
    func toEntity() -> Bread {
        Bread(
            breadId: breadId,
            breadName: breadName,
            isUnlocked: isUnlocked,
            requiredCount: requiredCount,
            imageUrl: imageUrl
        )
    }
}
