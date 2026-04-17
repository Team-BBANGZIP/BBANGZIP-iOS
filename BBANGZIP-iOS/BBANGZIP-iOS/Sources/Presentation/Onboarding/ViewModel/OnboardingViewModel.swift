//
//  OnboardingViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var userName: String = ""
    let maxNameLength: Int = 20
    @Published private(set) var selectedProfileImageKey: Int? = nil
    @Published var showImagePicker: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let signUpUseCase: SignUpUseCase
    
    private let profileImageKeyMap: [String: Int] = [
        "profile_basic": 0,
        "Profile_1": 1,
        "Profile_2": 2,
        "Profile_3": 3,
        "Profile_4": 4,
        "Profile_5": 5,
        "Profile_6": 6
    ]
    
    var nameFilled: Bool {
        !userName.isEmpty
    }
    
    var canSave: Bool {
        !userName.isEmpty && selectedProfileImageKey != nil
    }
    
    init(signUpUseCase: SignUpUseCase = SignUpUseCaseImpl()) {
        self.signUpUseCase = signUpUseCase
    }
    
    func openImagePicker() {
        showImagePicker = true
    }
    
    func setProfileImage(_ key: Int) {
        selectedProfileImageKey = key
    }
    
    func validateNameInput(_ newValue: String) {
        if newValue.count > maxNameLength {
            userName = String(newValue.prefix(maxNameLength))
            return
        }
        if containsEmoji(newValue) {
            userName = removeEmojis(from: newValue)
        }
    }

    private func containsEmoji(_ text: String) -> Bool {
        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                0x1F300...0x1F5FF,
                0x1F680...0x1F6FF,
                0x2600...0x26FF,
                0x2700...0x27BF,
                0x1F900...0x1F9FF,
                0x1FA70...0x1FAFF,
                0x1F1E6...0x1F1FF:
                return true
            default:
                continue
            }
        }
        return false
    }

    private func removeEmojis(from text: String) -> String {
        text.unicodeScalars.filter {
            switch $0.value {
            case 0x1F600...0x1F64F,
                0x1F300...0x1F5FF,
                0x1F680...0x1F6FF,
                0x2600...0x26FF,
                0x2700...0x27BF,
                0x1F900...0x1F9FF,
                0x1FA70...0x1FAFF,
                0x1F1E6...0x1F1FF:
                return false
            default:
                return true
            }
        }
        .map(String.init)
        .joined()
    }
    
    func saveProfile() async {
        guard canSave else { return }
        
        guard let profileImageKey = selectedProfileImageKey else {
            errorMessage = "프로필 이미지를 선택해주세요."
            return
        }
        
        guard !userName.isEmpty else {
            errorMessage = "닉네임을 입력해주세요."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await signUpUseCase.execute(
                nickname: userName,
                profileImageKey: profileImageKey
            )
            
            if result.isSuccess {
                UserDefaults.standard.set(
                    userName,
                    forKey: "userName"
                )
                UserDefaults.standard.set(
                    selectedProfileImageKey,
                    forKey: "profileImage"
                )
                
                NotificationCenter.default.post(
                    name: NSNotification.Name("OnboardingCompleted"),
                    object: nil
                )
            } else {
                errorMessage = "회원가입에 실패했습니다."
            }
        } catch {
            errorMessage = "회원가입 중 오류가 발생했습니다: \(error.localizedDescription)"
            LoggerFactory.create(category: .data).error("Sign Up Failed: \(error)")
        }
        
        isLoading = false
    }
}
