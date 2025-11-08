//
//  ChangeProfileViewModel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/27/25.
//

import SwiftUI

final class ChangeProfileViewModel: ObservableObject {
    @Published var isChangeProfileImageSheetPresented: Bool = false
    @Published var isChangeNickNameSheetPresented: Bool = false
    @Published var isMyPromiseSheetPresented: Bool = false
    
    func showChangeProfileImageSheet() {
        isChangeProfileImageSheetPresented = true
    }
    
    func showChangeNickNameSheet() {
        isChangeNickNameSheetPresented = true
    }
    
    func showMyPromiseSheet() {
        isMyPromiseSheetPresented = true
    }
    
    func updateMyPromiseMessage(_ newValue: String) {
        // TODO: 서버 연동
    }
    
    func updateNickName(_ newValue: String) {
        // TODO: 서버 연동
    }
}
