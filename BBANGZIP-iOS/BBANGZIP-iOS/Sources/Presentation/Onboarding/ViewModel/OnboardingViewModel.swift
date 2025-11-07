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
    
    var nameFilled: Bool {
        !userName.isEmpty
    }
    
    var canSave: Bool {
        !userName.isEmpty && selectedProfileImage != nil
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
    
    func saveProfile() {
        guard canSave else { return }
        
        UserDefaults.standard.set(
            userName,
            forKey: "userName"
        )
        UserDefaults.standard.set(
            selectedProfileImage,
            forKey: "profileImage"
        )
        UserDefaults.standard.set(
            true,
            forKey: "hasCompletedOnboarding"
        )
        
        NotificationCenter.default.post(
            name: NSNotification.Name(
                "OnboardingCompleted"
            ),
            object: nil
        )
    }
}
