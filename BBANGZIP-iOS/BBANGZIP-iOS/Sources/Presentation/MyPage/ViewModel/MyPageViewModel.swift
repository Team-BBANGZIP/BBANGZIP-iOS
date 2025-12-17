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
    @Published var profileImageKey: Int = 1
    @Published var nickname: String = ""
    @Published var commitmentMessage: String = ""
    @Published var showSignOutAlert: Bool = false
    @Published var showWithdrawAlert: Bool = false
    @Published var isLoading: Bool = false
    
    private let getProfileUseCase: GetProfileUseCase
    private let signOutUseCase: SignOutUseCase
    private let withdrawUseCase: WithdrawUseCase
    
    init(
        getProfileUseCase: GetProfileUseCase,
        signOutUseCase: SignOutUseCase,
        withdrawUseCase: WithdrawUseCase
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.signOutUseCase = signOutUseCase
        self.withdrawUseCase = withdrawUseCase
        
        Task {
            await fetchProfile()
        }
    }
    
    func fetchProfile() async {
        do {
            let profile = try await getProfileUseCase.getProfile()
            print("Fetched profile: ", profile)
            
            await MainActor.run {
                self.profileImageUrl = profile.profileImageUrl ?? ""
                self.profileImageKey = profile.profileImageKey ?? 1
                self.nickname = profile.nickname
                self.commitmentMessage = profile.commitmentMessage ?? "나만의 다짐을 적어보세요"
            }
        } catch {
            print("fetch Profile Error: \(error.localizedDescription)")
        }
    }
    
    func signOut() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let success = try await signOutUseCase.execute()
            if success {
                TokenManager.shared.clearTokens()
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("AuthenticationFailed"),
                    object: nil
                )
            }
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
            TokenManager.shared.clearTokens()
            NotificationCenter.default.post(
                name: NSNotification.Name("AuthenticationFailed"),
                object: nil
            )
        }
    }
    
    func withdraw() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let success = try await withdrawUseCase.execute()
            if success {
                TokenManager.shared.clearTokens()
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("AuthenticationFailed"),
                    object: nil
                )
            }
        } catch {
            print("Withdraw failed: \(error.localizedDescription)")
            TokenManager.shared.clearTokens()
            NotificationCenter.default.post(
                name: NSNotification.Name("AuthenticationFailed"),
                object: nil
            )
        }
    }
}
