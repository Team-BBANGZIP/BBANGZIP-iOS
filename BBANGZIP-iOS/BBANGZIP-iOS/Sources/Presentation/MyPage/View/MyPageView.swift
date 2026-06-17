//
//  MyPageView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/1/25.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    @StateObject private var viewModel: MyPageViewModel
    @State private var navigationPath = NavigationPath()
    @State private var isActive = false
    @Binding var isInSubView: Bool
    private let isGuest: Bool
    private let onLoginTapped: () -> Void
    
    init(
        isInSubView: Binding<Bool> = .constant(false),
        isGuest: Bool = false,
        onLoginTapped: @escaping () -> Void = {}
    ) {
        self._isInSubView = isInSubView
        self.isGuest = isGuest
        self.onLoginTapped = onLoginTapped
        let repository = AuthRepositoryImpl()
        _viewModel = StateObject(
            wrappedValue: MyPageViewModel(
                getProfileUseCase: GetProfileUseCaseImpl(repository: ProfileRepository()),
                signOutUseCase: SignOutUseCaseImpl(repository: repository),
                withdrawUseCase: WithdrawUseCaseImpl(repository: repository)
            )
        )
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(.secondaryLight), location: 0.0),
                        .init(color: Color(.secondaryLight), location: 0.5),
                        .init(color: Color(.backgroundNomal), location: 0.5),
                        .init(color: Color(.backgroundNomal), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        ProfileSection
                            .padding(.top, 32)
                        
                        SettingSection
                            .padding(.top, 32)
                    }
                }
                
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "SettingScreen" {
                    SettingScreenView()
                }
                if destination == "ChangeProfile" {
                    if !isGuest {
                        ChangeProfileView(
                            onSave: { newNickname, newMessage in
                                viewModel.nickname = newNickname
                                viewModel.commitmentMessage = newMessage
                            }
                        )
                    }
                }
            }
            .sheet(isPresented: $viewModel.showSignOutAlert) {
                SignOutBottomSheet(
                    isPresented: $viewModel.showSignOutAlert,
                    categoryName: "",
                    onDelete: {
                        Task {
                            await viewModel.signOut()
                        }
                    }
                )
                .presentationDetents([.height(350)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.showWithdrawAlert) {
                WithdrawBottomSheet(
                    isPresented: $viewModel.showWithdrawAlert,
                    categoryName: "",
                    onDelete: {
                        Task {
                            await viewModel.withdraw()
                        }
                    }
                )
                .presentationDetents([.height(350)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
            }
            .onChange(of: navigationPath) { _, _ in
                isInSubView = !navigationPath.isEmpty
            }
            .onAppear {
                if isGuest {
                    viewModel.nickname = "게스트"
                    viewModel.commitmentMessage = "데이터는 이 기기에만 저장돼요"
                } else {
                    Task {
                        await viewModel.fetchProfile()
                    }
                }
            }
        }
    }
    
    private var ProfileSection: some View {
        VStack(spacing: 20) {
            HStack {
                BbangText(
                    "프로필",
                    font: .title1,
                    color: Color(.labelStrong)
                )
                .padding(.leading, 20)
                
                Spacer()
            }
            
            Button {
                if isGuest {
                    onLoginTapped()
                } else {
                    navigationPath.append("ChangeProfile")
                }
            } label: {
                HStack(spacing: 12) {
//                    if let url = URL(string: viewModel.profileImageUrl) {
//                        KFImage(url)
//                            .resizable()
//                            .placeholder { Image(.icProfile).resizable() }
//                            .frame(width: 60, height: 60)
//                            .clipShape(Circle())
//                    }
//                    else {
//                        Image(.icProfile)
//                            .resizable()
//                            .frame(width: 60, height: 60)
//                            .clipShape(Circle())
//                    }
                    Image(viewModel.profileImageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 0) {
                            BbangText(
                                viewModel.nickname.isEmpty ? "유나쨩" : viewModel.nickname,
                                font: .title4,
                                color: Color(.labelStrong)
                            )
                            
                            Image(.icPencil)
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color(.labelAssistive))
                        }
                        
                        BbangText(
                            viewModel.commitmentMessage.isEmpty ? "나만의 다짐을 적어보세요" : viewModel.commitmentMessage,
                            font: .subtitle1,
                            color: Color(.labelAlternative)
                        )
                        .lineLimit(1)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .contentShape(Rectangle())
            }
                .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var SettingSection: some View {
        ZStack {
            Color(.backgroundNomal)
                .cornerRadius(30)
            
            VStack(spacing: 12) {
                if isGuest {
                    guestDataNotice
                        .padding(.bottom, 8)
                }

                HStack {
                    Image(.icScreen)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 4)
                    
                    Spacer()
                }
                
                MenuBox(
                    menu: "화면 설정",
                    onMenuTapped: {
                        navigationPath.append("SettingScreen")
                    }
                )
// TODO : 알림설정 기능 구현 후 반영
//                settingDivider
//                    .padding(.vertical, 12)
//                
//                HStack {
//                    Image(.icNotification)
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                        .padding(.leading, 4)
//                    
//                    Spacer()
//                }
//                
//                MenuBox(
//                    menu: "알림 설정",
//                    onMenuTapped: {
//                        print("알림 설정")
//                    }
//                )
                
                settingDivider
                    .padding(.vertical, 12)
                
                HStack {
                    Image(.icService)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 4)
                    
                    Spacer()
                }
                
                MenuBox(
                    menu: "고객센터",
                    onMenuTapped: {
                        openURL("https://southern-comet-4a3.notion.site/2ac01508929380518f17feaa3aa64870")
                    }
                )
                
                MenuBox(
                    menu: "제 과제 빵점 사용법",
                    onMenuTapped: {
                        openURL("https://www.instagram.com/bbangzip.official/")
                    }
                )
                
                MenuBox(
                    menu: "피드백 남기기",
                    onMenuTapped: {
                        openURL("https://forms.gle/F78qHjofp1ERFFFL8")
                    }
                )
                
                MenuBox(
                    menu: "앱 리뷰 남기기",
                    onMenuTapped: {
                        openURL("https://apps.apple.com/app/id6762832051?action=write-review")
                    }
                )
                
                HStack {
                    BbangText(
                        "버전정보",
                        font: .body2,
                        color: Color(.labelNormal)
                    )
                    
                    Spacer()
                    
                    BbangText(
                        "v \(appVersion)",
                        font: .body2,
                        color: Color(.labelAssistive)
                    )
                    .padding(.trailing, 4)
                }
                .frame(height: 44)
                
                if isGuest {
                    Button(action: onLoginTapped) {
                        BbangText(
                            "로그인하기",
                            font: .body4,
                            color: Color(.labelAssistive)
                        )
                    }
                    .padding(.top, 5)
                } else {
                    HStack(spacing: 12) {
                        Spacer()
                        
                        Button(action: {
                            viewModel.showSignOutAlert = true
                        }) {
                            BbangText(
                                "로그아웃",
                                font: .body4,
                                color: Color(.labelAssistive)
                            )
                        }
                        
                        Rectangle()
                            .frame(width: 1, height: 16)
                            .foregroundStyle(Color(.labelAssistive))
                        
                        Button(action: {
                            viewModel.showWithdrawAlert = true
                        }) {
                            BbangText(
                                "회원 탈퇴",
                                font: .body4,
                                color: Color(.labelAssistive)
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 5)
                }
                
                Spacer()
                    .frame(height: 32)
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)
        }
    }

    private var guestDataNotice: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(.icAlert)
                .resizable()
                .renderingMode(.template)
                .frame(width: 18, height: 18)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 1)

            BbangText(
                "게스트 모드의 데이터는 이 기기에만 저장되며,\n앱을 삭제하면 복구할 수 없어요.",
                font: .label4,
                color: Color(.labelAlternative)
            )
            .multilineTextAlignment(.leading)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.secondaryLight))
        .cornerRadius(12)
    }
    
    private var settingDivider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color(.secondaryNormal))
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }
        UIApplication.shared.open(url)
    }
}
