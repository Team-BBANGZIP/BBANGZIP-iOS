//
//  GetBreadsRepository.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/3/25.
//

import Foundation

protocol GetBreadsRepositoryProtocol: Sendable {
    func getBreads(
    ) async throws -> BreadList
}

final class GetBreadsRepository: GetBreadsRepositoryProtocol {
    private let api: API

    init(
        api: API = .shared
    ) {
        self.api = api
    }
    
    func getBreads() async throws -> BreadList {
        let router = BbangRouter.getBreads
        
        do {
            let response: BreadsResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("getBreads: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("getBreads: \(error.localizedDescription)")
            
            throw error
        }
    }
}
