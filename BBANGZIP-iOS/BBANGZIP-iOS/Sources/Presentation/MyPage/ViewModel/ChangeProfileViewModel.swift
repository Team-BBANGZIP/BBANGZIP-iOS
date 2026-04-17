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
    @Published var isMyPromiseSheetPresented: Bool = false
    
    @Published var profileImageUrl: String = ""
    @Published var profileImageKey: Int = 1
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
    
    var profileImageName: String {
        switch profileImageKey {
        case 0:
            return "icProfile"
        case 1...6:
            return "Profile_\(profileImageKey)"
        default:
            return "icProfile"
        }
    }
    
    var currentProfileImageName: String {
        if let selected = selectedProfileImage,
           let key = profileImageKeyMap[selected] {
            return key == 0 ? "icProfile" : "Profile_\(key)"
        }
        return profileImageName
    }
    
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
            print("profile: ", profile)
            
            self.profileImageUrl = profile.profileImageUrl ?? ""
            self.nickname = profile.nickname
            self.commitmentMessage = profile.commitmentMessage ?? "나만의 다짐을 적어보세요"
            self.profileImageKey = profile.profileImageKey ?? 1

            print("Current profileImageKey: \(self.profileImageKey)")
        } catch {
            print("fetch Profile Error: \(error.localizedDescription)")
        }
    }
    
    func showChangeProfileImageSheet() {
        isChangeProfileImageSheetPresented = true
    }
    
    func saveProfile() async {
        await updateNickName(nickname)
    }

    func showMyPromiseSheet() {
        isMyPromiseSheetPresented = true
    }
    
    func updateMyProfileImage(_ imageName: String) {
        selectedProfileImage = imageName
        
        guard let profileImage = selectedProfileImage,
              let newProfileImageKey = profileImageKeyMap[profileImage] else {
            print("❌ Invalid profile image key")
            return
        }
        
        Task {
            do {
                let response = try await updateProfileUseCase.updateProfileImage(
                    profileImageKey: newProfileImageKey
                )
                
                await MainActor.run {
                    if let newImageUrl = response.profileImageUrl {
                        self.profileImageUrl = newImageUrl
                        self.profileImageKey = newProfileImageKey
                    }
                }
                
                print("- new key: \(newProfileImageKey)")
            }
            catch {
                print("프로필 이미지 변경 실패: ", error)
            }
        }
    }
    
    func updateMyPromiseMessage(_ newValue: String) {
        Task {
            do {
                _ = try await updateProfileUseCase.updateCommitmentMessage(
                    commitmentMessage: newValue,
                    currentProfileImageKey: profileImageKey
                )
                
                await MainActor.run {
                    self.commitmentMessage = newValue
                }
                
                print("상태메시지 변경 성공")
            }
            catch {
                print("상태메시지 변경 실패: ", error)
            }
        }
    }
    
    func updateNickName(_ newValue: String) async {
        do {
            _ = try await updateProfileUseCase.updateNickname(
                nickname: newValue,
                currentProfileImageKey: profileImageKey
            )
            self.nickname = newValue
            print("닉네임 변경 성공")
        } catch {
            print("닉네임 변경 실패: ", error)
        }
    }
}
