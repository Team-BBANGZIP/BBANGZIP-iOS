//
//  LoginViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 9/24/25.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
final class LoginViewModel: NSObject, ObservableObject {
    
    @Published var showTitle = false
    @Published var showBbangBackground = false
    @Published var showKakao = false
    @Published var showApple = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var started = false
    nonisolated private let signInUseCase: SignInUseCase
    
    init(signInUseCase: SignInUseCase = SignInUseCaseImpl(repository: AuthRepositoryImpl())) {
        self.signInUseCase = signInUseCase
        super.init()
    }
    
    func startIntroAnimation() {
        guard !started else { return }
        started = true
        
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            withAnimation(.easeInOut(duration: 0.5)) {
                self.showTitle = true
            }
            
            try? await Task.sleep(nanoseconds: 700_000_000)
            withAnimation(.easeOut(duration: 0.6)) {
                self.showBbangBackground = true
            }
            
            try? await Task.sleep(nanoseconds: 900_000_000)
            withAnimation(.easeInOut(duration: 0.4)) {
                self.showKakao = true
            }
            
            try? await Task.sleep(nanoseconds: 600_000_000)
            withAnimation(.easeInOut(duration: 0.4)) {
                self.showApple = true
            }
        }
    }
    
    func tapKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginWithKakaoTalk()
        } else {
            loginWithKakaoAccount()
        }
    }
    
    private func loginWithKakaoTalk() {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                LoggerFactory.create(category: .data)
                    .error("Kakao Talk Login Failed: \(error)")
                self.errorMessage = "카카오 로그인에 실패했습니다."
            } else if let token = oauthToken {
                LoggerFactory.create(category: .data)
                    .debug("Kakao Talk Login Success")
                self.handleKakaoSignIn(accessToken: token.accessToken)
            }
        }
    }
    
    private func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            guard let self = self else { return }
            
            if let error = error {
                LoggerFactory.create(category: .data)
                    .error("Kakao Account Login Failed: \(error)")
                self.errorMessage = "카카오 로그인에 실패했습니다."
            } else if let token = oauthToken {
                LoggerFactory.create(category: .data)
                    .debug("Kakao Account Login Success")
                self.handleKakaoSignIn(accessToken: token.accessToken)
            }
        }
    }
    
    private func handleKakaoSignIn(accessToken: String) {
        isLoading = true
        errorMessage = nil
        
        Task { @MainActor in
            do {
                let result = try await signInUseCase.execute(
                    provider: .kakao,
                    providerToken: accessToken,
                    role: .user
                )
                
                isLoading = false
                
                if result.isSignUpComplete {
                    // TODO: 메인 화면으로 이동
                } else {
                    // TODO: 온보딩 화면으로 이동
                }
                
            } catch {
                isLoading = false
                errorMessage = "로그인에 실패했습니다."
                LoggerFactory.create(category: .data).error("Kakao Sign In Failed: \(error)")
            }
        }
    }
    
    func tapApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [
            .fullName,
            .email
        ]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func handleAppleSignIn(identityToken: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await signInUseCase.execute(
                    provider: .apple,
                    providerToken: identityToken,
                    role: .user
                )
                
                isLoading = false
                
                if result.isSignUpComplete {
                    // TODO: 메인 화면으로 이동
                } else {
                    // TODO: 온보딩 화면으로 이동
                }
                
            } catch {
                isLoading = false
                errorMessage = "로그인에 실패했습니다."
                LoggerFactory.create(category: .data).error("Apple Sign In Failed: \(error)")
            }
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(
                data: identityTokenData,
                encoding: .utf8
              ) else {
            errorMessage = "Apple 인증 정보를 가져올 수 없습니다."
            return
        }
        
        handleAppleSignIn(identityToken: identityToken)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        guard let authError = error as? ASAuthorizationError else {
            errorMessage = "로그인 중 오류가 발생했습니다."
            return
        }
        
        switch authError.code {
        case .canceled:
            errorMessage = nil
        default:
            errorMessage = "로그인에 실패했습니다."
        }
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            fatalError("No window found")
        }
        return window
    }
}
