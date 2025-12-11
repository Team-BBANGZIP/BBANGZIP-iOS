//
//  SignOutBottomSheet.swift
//  BBANGZIP
//
//  Created by 송여경 on 12/12/25.
//

import SwiftUI

struct SignOutBottomSheet: View {
    @Binding var isPresented: Bool
    let categoryName: String
    let onDelete: () -> Void
    
    var body: some View {
        Text("정말 로그아웃 하시겠어요?")
            .bbangFont(.title1)
            .foregroundStyle(Color(.primaryNormal))
            .padding(.top, 41)
        
        Text("로그아웃 시 다시 로그인 하기 전까지\n서비스 내 모든 기능을 이용할 수 없습니다.\n\n로그아웃을 진행할까요?")            .bbangFont(.body2)
            .foregroundStyle(Color(.labelAlternative))
            .multilineTextAlignment(.center)
            .padding(.vertical, 60)
        
        buttons
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
    }
    
    var buttons: some View {
        HStack(spacing: 15) {
            Button("취소하기") {
                isPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                )
            )
            
            Button("로그아웃하기") {
                onDelete()
                isPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary
                )
            )
        }
    }
}
