//
//  ChangeProfileViewModel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/27/25.
//

import SwiftUI

@MainActor
final class ChangeProfileViewModel: ObservableObject {
    @Published var isChangeProfileImageSheetPresented: Bool = false
    @Published var isChangeNickNameSheetPresented: Bool = false
    @Published var isMyPromiseSheetPresented: Bool = false
    
    @Published var profileImageUrl: String = ""
    @Published var nickname: String = ""
    @Published var commitmentMessage: String = ""
    @Published private(set) var selectedProfileImage: String? = nil
    
    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    
    private let profileImageKeyMap: [String: Int] = [
        "profile_basic": 0,
        "Profile_1": 1,
        "Profile_2": 2,
        "Profile_3": 3,
        "Profile_4": 4,
        "Profile_5": 5,
        "Profile_6": 6
    ]
    
    init(
        getProfileUseCase: GetProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
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
    
    func showChangeProfileImageSheet() {
        isChangeProfileImageSheetPresented = true
    }
    
    func showChangeNickNameSheet() {
        isChangeNickNameSheetPresented = true
    }
    
    func showMyPromiseSheet() {
        isMyPromiseSheetPresented = true
    }
    
    func updateMyProfileImage(_ imageName: String) {
        selectedProfileImage = imageName
        
        guard let profileImage = selectedProfileImage,
              let profileImageKey = profileImageKeyMap[profileImage] else {
            return
        }
        
        Task {
            do {
                let response = try await updateProfileUseCase.updateProfileImage(
                    profileImageKey: profileImageKey
                )
                
                await MainActor.run {
                    if let newImageUrl = response.profileImageUrl {
                        self.profileImageUrl = newImageUrl
                    }
                }
                
                print("프로필 이미지 변경 성공")
            }
            catch {
                print("프로필 이미지 변경 실패 : ", error)
            }
        }
    }
    
    func updateMyPromiseMessage(_ newValue: String) {
        self.commitmentMessage = newValue
        
        Task {
            do {
                _ = try await updateProfileUseCase.updateCommitmentMessage(
                    commitmentMessage: newValue
                )
                
                print("상태메시지 변경 성공")
            }
            catch {
                print("상태메시지 변경 실패 : ", error)
            }
        }
    }
    
    func updateNickName(_ newValue: String) {
        self.nickname = newValue
        
        Task {
            do {
                _ = try await updateProfileUseCase.updateNickname(
                    nickname: newValue
                )
                
                print("닉네임 변경 성공")
            }
            catch {
                print("닉네임 변경 실패 : ", error)
            }
        }
    }
}
