//
//  LoginViewModel.swift
//  BBANGZIP
//
//  Created by 송여경 on 9/24/25.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var showTitle = false
    @Published var showBbangBackground = false
    @Published var showKakao = false
    @Published var showApple = false
    
    private var started = false
    
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
        //TODO: 카카오로그인 구현
        print("Kakao Login 눌림")
    }
    
    func tapApple() {
        //TODO: 애플로그인 구현
        print("Apple Login 눌림")
    }
}
