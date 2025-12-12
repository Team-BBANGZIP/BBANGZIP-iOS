//
//  WithdrawBottomSheet.swift
//  BBANGZIP
//
//  Created by 송여경 on 12/12/25.
//

import SwiftUI

struct WithdrawBottomSheet: View {
    @Binding var isPresented: Bool
    let categoryName: String
    let onDelete: () -> Void
    
    var body: some View {
        Text("정말 탈퇴 하시겠어요?")
            .bbangFont(.title1)
            .foregroundStyle(Color(.primaryNormal))
            .padding(.top, 41)
        
        Text("탈퇴 시 모든 정보가 삭제되며,\n삭제된 데이터 및 계정은 복구가 불가능합니다.\n\n회원 탈퇴를 진행할까요?")            .bbangFont(.body2)
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
                    style: .secondary
                )
            )
            
            Button("탈퇴하기") {
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
