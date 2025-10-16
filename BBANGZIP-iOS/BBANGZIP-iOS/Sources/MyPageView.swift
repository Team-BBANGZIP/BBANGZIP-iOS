//
//  MyPageView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/1/25.
//

import SwiftUI

struct MyPageView: View {
    @State private var navigationPath = NavigationPath()
    
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
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "SettingScreen" {
                    SettingScreenView()
                }
                if destination == "ChangeProfile" {
                    ChangeProfileView()
                }
            }
        }
    }
    
    private var ProfileSection: some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                navigationPath.append("ChangeProfile")
            }
        } label : {
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
                
                HStack(spacing: 12) {
                    Image(.icProfile)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 0) {
                            BbangText(
                                "유나쨩",
                                font: .title4,
                                color: Color(.labelStrong)
                            )
                            
                            Button(action: {
                                
                            }) {
                                Image(.icPencil)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(.labelAssistive))
                            }
                        }
                        
                        BbangText(
                            "지금 이 순간 쌓는 한 줄의 지식이, 내일의 너를 강하게 만든다",
                            font: .subtitle1,
                            color: Color(.labelAlternative)
                        )
                        .lineLimit(1)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var SettingSection: some View {
        ZStack {
            Color(.backgroundNomal)
                .cornerRadius(30)
            
            VStack(spacing: 12) {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigationPath.append("SettingScreen")
                    }
                })
                
                settingDivider
                    .padding(.vertical, 12)
                
                HStack {
                    Image(.icNotification)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 4)
                    
                    Spacer()
                }
                
                MenuBox(
                    menu: "알림 설정",
                    onMenuTapped: {
                        print("알림 설정")
                    }
                )
                
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
                        print("고객센터")
                    }
                )
                
                MenuBox(
                    menu: "제 과제 빵점 사용법",
                    onMenuTapped: {
                        print("제 과제 빵점 사용법")
                    }
                )
                
                MenuBox(
                    menu: "피드백 남기기",
                    onMenuTapped: {
                        print("피드백 남기기")
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
                
                HStack(spacing: 12) {
                    Spacer()
                    
                    Button(action: { print("로그아웃") }) {
                        BbangText(
                            "로그아웃",
                            font: .body4,
                            color: Color(.labelAssistive)
                        )
                    }
                    
                    Rectangle()
                        .frame(width: 1, height: 16)
                        .foregroundStyle(Color(.labelAssistive))
                    
                    Button(action: { print("회원 탈퇴") }) {
                        BbangText(
                            "회원 탈퇴",
                            font: .body4,
                            color: Color(.labelAssistive)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.top, 5)
                
                Spacer()
                    .frame(height: 32)
            }
            .padding(.top, 32)
            .padding(.horizontal, 20)
        }
    }
    
    private var settingDivider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(Color(.secondaryNormal))
    }
}

#Preview {
    MyPageView()
}
