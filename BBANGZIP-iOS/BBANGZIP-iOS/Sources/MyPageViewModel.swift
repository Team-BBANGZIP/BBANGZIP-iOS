//
//  MyPageViewModel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/30/25.
//

import SwiftUI

@MainActor
final class MyPageViewModel: ObservableObject {
    @Published var profileImageUrl: String = ""
    @Published var nickname: String = ""
    @Published var commitmentMessage: String = ""
    
    private let getProfileUseCase: GetProfileUseCase
    
    init(getProfileUseCase: GetProfileUseCase) {
        self.getProfileUseCase = getProfileUseCase
        Task {
            await fetchProfile()
        }
    }
    
    func fetchProfile() async {
        do {
            let profile = try await getProfileUseCase.getProfile()
            print("profile ", profile)
            self.profileImageUrl = profile.profileImageUrl ?? ""
            self.nickname = profile.nickname
            self.commitmentMessage = profile.commitmentMessage ?? "나만의 다짐을 적어보세요"
        } catch {
            print("fetch Profile Error: \(error.localizedDescription)")
        }
    }
}
