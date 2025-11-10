//
//  GetBreadsUseCase.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/3/25.
//

import Foundation

protocol GetBreadsUseCaseProtocol: Sendable {
    func execute() async throws -> BreadList
}

final class GetBreadsUseCase: GetBreadsUseCaseProtocol {
    private let repository: GetBreadsRepository
    
    init(repository: GetBreadsRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> BreadList {
        
        return try await repository.getBreads()
    }
}
