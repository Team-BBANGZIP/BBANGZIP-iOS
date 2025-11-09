//
//  AddCategoryRepository.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/28/25.
//

import Foundation

protocol AddCategoryRepositoryProtocol: Sendable {
    func addCategory(request: CategoryAddRequestDTO) async throws -> AddCategory
}

final class AddCategoryRepository: AddCategoryRepositoryProtocol {
    private let api: API
    private let tokenManager: TokenManager

    init(
        api: API = API(),
        tokenManager: TokenManager = .shared
    ) {
        self.api = api
        self.tokenManager = tokenManager
    }

    func addCategory(request: CategoryAddRequestDTO) async throws -> AddCategory {
        guard let accessToken = tokenManager.getAccessToken() else {
            LoggerFactory.create(category: .data)
                .error("AddCategory Error: AccessToken is nil")
            throw AuthError.invalidToken
        }

        let router = BbangRouter.addCategory(dto: request)

        do {
            let response: CategoryAddResponseDTO = try await api.request(api: router)

            let okCodes: Set<Int> = [20000, 20100]
            guard okCodes.contains(response.code) else {
                LoggerFactory.create(category: .data)
                    .error("AddCategory Error: Unexpected response code \(response.code)")
                throw RouterError.server(message: "AddCategory Error: Unexpected \(response.code)")
            }

            return response.data.toAddCategory()

        } catch {
            LoggerFactory.create(category: .data)
                .error("AddCategory Request Failed: \(error.localizedDescription)")
            throw error
        }
    }
}
