//
//  SignUpRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/8/25.
//

import Foundation

protocol SignUpRepository: Sendable {
    func signUp(
        nickname: String,
        profileImageKey: Int
    ) async throws -> SignUp
}

final class SignUpRepositoryImpl: SignUpRepository {
    private let api: API
    
    init(api: API = API()) {
        self.api = api
    }
    
    func signUp(
        nickname: String,
        profileImageKey: Int
    ) async throws -> SignUp {
        let requestDTO = SignUpRequestDTO(
            nickname: nickname,
            profileImageKey: profileImageKey
        )
        
        let router = BbangRouter.signUp(dto: requestDTO)
        
        do {
            let response: SignUpResponseDTO = try await api.request(api: router)
            return response.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("SignUp Error: \(error.localizedDescription)")
            throw error
        }
    }
}
