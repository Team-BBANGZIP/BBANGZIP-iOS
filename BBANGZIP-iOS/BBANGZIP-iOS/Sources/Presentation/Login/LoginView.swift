//
//  LoginView.swift
//  BBANGZIP
//
//  Created by 송여경 on 9/24/25.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var vm = LoginViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.backgroundStrong)
                    .ignoresSafeArea()
                    .zIndex(-1)
                
                VStack(spacing: 0) {
                    VStack {
                        Spacer()
                            .frame(height: 195)
                        
                        HStack {
                            Spacer()
                                .frame(width: 61)
                            Image(.slogan)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 252, height: 76)
                                .opacity(vm.showTitle ? 1 : 0)
                                .offset(y: vm.showTitle ? 0 : -30)
                            Spacer()
                                .frame(width: 61)
                        }
                        
                        Spacer()
                    }
                    .ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        KakaoLoginButton { vm.tapKakao() }
                            .opacity(vm.showKakao ? 1 : 0)
                            .offset(y: vm.showKakao ? 0 : 8)
                        
                        AppleLoginButton { vm.tapApple() }
                            .opacity(vm.showApple ? 1 : 0)
                            .offset(y: vm.showApple ? 0 : 8)
                        
                        Button {
                            NotificationCenter.default.post(
                                name: NSNotification.Name("ContinueAsGuest"),
                                object: nil
                            )
                        } label: {
                            Text("게스트로 시작하기")
                                .bbangFont(.body2)
                                .foregroundColor(Color(.labelAlternative))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                        }
                        .opacity(vm.showApple ? 1 : 0)
                        .offset(y: vm.showApple ? 0 : 8)
                        
                        Spacer()
                            .frame(height: 20)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28 + safeBottomInset())
                }
                
                Image(.bangBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .bottom
                    )
                    .opacity(vm.showBbangBackground ? 1 : 0)
                    .ignoresSafeArea(edges: .bottom)
                    .zIndex(-1)
                
                if vm.isLoading {
                    LoadingView()
                }
            }
            .onAppear { vm.startIntroAnimation() }
        }
        .preferredColorScheme(.light)
        .alert("로그인 오류", isPresented: .constant(vm.errorMessage != nil)) {
            Button("확인") {
                vm.errorMessage = nil
            }
        } message: {
            if let errorMessage = vm.errorMessage {
                Text(errorMessage)
            }
        }
        .onChange(of: vm.shouldShowOnboarding) { oldValue, newValue in
            if newValue {
                NotificationCenter.default.post(
                    name: NSNotification.Name("ShowOnboarding"),
                    object: nil
                )
            }
        }
        .onChange(of: vm.shouldNavigateToMain) { oldValue, newValue in
            if newValue {
                NotificationCenter.default.post(
                    name: NSNotification.Name("LoginSuccess"),
                    object: nil
                )
            }
        }
    }
    
    private func safeBottomInset() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .safeAreaInsets.bottom ?? 0
    }
}

private struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}

struct KakaoLoginButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(.kakaoIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("카카오로 로그인하기")
                    .bbangFont(.body1)
                    .foregroundColor(Color(.kakaoLabel))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color(.kakaoContainer))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 30,
                    style: .continuous
                )
            )
        }
    }
}

struct AppleLoginButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "apple.logo")
                    .frame(width: 20, height: 20)
                    .font(
                        .system(
                            size: 20,
                            weight: .medium
                        )
                    )
                    .foregroundColor(.white)
                Text("Apple로 로그인하기")
                    .bbangFont(.body1)
                    .foregroundColor(Color(.appleLabel))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color.black)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 30,
                    style: .continuous
                )
            )
        }
    }
}

#Preview {
    LoginView().environment(\.colorScheme, .light)
}
