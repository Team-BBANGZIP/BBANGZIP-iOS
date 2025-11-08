//
//  SignUpRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 11/8/25.
//

import Foundation
import Alamofire

protocol SignUpRepository: Sendable {
    func signUp(
        nickname: String,
        profileImageKey: Int
    ) async throws -> SignUp
}

final class SignUpRepositoryImpl: SignUpRepository {
    func signUp(nickname: String, profileImageKey: Int) async throws -> SignUp {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            throw NSError(
                domain: "SignUpRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Access token not found"]
            )
        }
        
        let requestDTO = SignUpRequestDTO(
            nickname: nickname,
            profileImageKey: profileImageKey
        )
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                BbangRouter.signUp(dto: requestDTO, accessToken: accessToken)
            )
            .validate()
            .responseDecodable(of: SignUpResponseDTO.self) { response in
                switch response.result {
                case .success(let dto):
                    continuation.resume(returning: dto.toEntity())
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
