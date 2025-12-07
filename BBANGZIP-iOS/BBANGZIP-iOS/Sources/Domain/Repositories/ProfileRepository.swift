//
//  ProfileRepository.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/30/25.
//

import Foundation

protocol ProfileRepositoryProtocol: Sendable {
    func getProfile() async throws -> Profile
    
    func updateProfile(request: ProfileUpdateRequestDTO) async throws -> Profile
}

final class ProfileRepository: ProfileRepositoryProtocol {
    private let api: API
    
    init(
        api: API = .shared
    ) {
        self.api = api
    }
    
    func getProfile() async throws -> Profile {
        let router = BbangRouter.getProfile
        
        do {
            let response: ProfileResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("getProfile: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("getProfile: \(error.localizedDescription)")
            
            throw error
        }
    }
    
    func updateProfile(request: ProfileUpdateRequestDTO) async throws -> Profile {
        let router = BbangRouter.updateProfile(dto: request)
        
        do {
            let response: ProfileResponseDTO = try await api.request(api: router)
            
            if response.code != 20000 {
                LoggerFactory.create(category: .data)
                    .error("updateProfile: Unexpected response code \(response.code)")
            }
            return response.data.toEntity()
        } catch {
            LoggerFactory.create(category: .data)
                .error("updateProfile: \(error.localizedDescription)")
            
            throw error
        }
    }
}
