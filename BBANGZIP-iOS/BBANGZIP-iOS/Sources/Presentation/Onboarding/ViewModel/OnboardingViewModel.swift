//
//  OnboardingViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var userName: String = ""
    @Published private(set) var selectedProfileImage: String? = "profile_basic"
    @Published var showImagePicker: Bool = false
    @Published var showNameInput: Bool = false
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
        !userName.isEmpty && selectedProfileImage != nil
    }
    
    init(signUpUseCase: SignUpUseCase = SignUpUseCaseImpl()) {
        self.signUpUseCase = signUpUseCase
    }
    
    func openImagePicker() {
        showImagePicker = true
    }
    
    func openNameInput() {
        showNameInput = true
    }
    
    func setProfileImage(_ imageName: String) {
        selectedProfileImage = imageName
    }
    
    func setUserName(_ name: String) {
        userName = name
    }
    
    func saveProfile() async {
        guard canSave else { return }
        
        guard let profileImage = selectedProfileImage,
              let profileImageKey = profileImageKeyMap[profileImage] else {
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
                    selectedProfileImage,
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
