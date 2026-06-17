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
import KakaoSDKCommon

@MainActor
final class LoginViewModel: NSObject, ObservableObject {
    
    @Published var showTitle = false
    @Published var showBbangBackground = false
    @Published var showKakao = false
    @Published var showApple = false
    @Published var showGuest = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var shouldShowOnboarding = false
    @Published var shouldNavigateToMain = false
    
    private var started = false
    private let signInUseCase: SignInUseCase
    
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

            try? await Task.sleep(nanoseconds: 250_000_000)
            withAnimation(.easeInOut(duration: 0.35)) {
                self.showGuest = true
            }
        }
    }
    
    func tapKakao() {
        guard !isLoading else { return }
        isLoading = true

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
                self.isLoading = false
                if let sdkError = error as? SdkError, case .ClientFailed(.Cancelled, _) = sdkError {
                    return
                }
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
                self.isLoading = false
                if let sdkError = error as? SdkError, case .ClientFailed(.Cancelled, _) = sdkError {
                    return // 사용자가 취소 → 알럿 없이 조용히 종료
                }
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
                
                LoggerFactory.create(category: .data).debug("Login Success - Token saved")
                LoggerFactory.create(category: .data).debug("isSignUpComplete: \(result.isSignUpComplete)")
                
                isLoading = false
                
                if result.isSignUpComplete {
                    UserDefaults.standard.set(true, forKey: "isSignUpComplete")
                    shouldNavigateToMain = true
                } else {
                    shouldShowOnboarding = true
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
                
                LoggerFactory.create(category: .data).debug("Login Success - Token saved")
                LoggerFactory.create(category: .data).debug("isSignUpComplete: \(result.isSignUpComplete)")
                
                isLoading = false
                
                if result.isSignUpComplete {
                    UserDefaults.standard.set(true, forKey: "isSignUpComplete")
                    shouldNavigateToMain = true
                } else {
                    shouldShowOnboarding = true
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
