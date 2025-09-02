//
//  CategoryDeleteAlertView.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/31/25.
//

import SwiftUI

struct CategoryDeleteAlertView: View {
    @Binding var isPresented: Bool
    let categoryName: String
    let onDelete: () -> Void
    
    var body: some View {
        Text("정말 삭제하시겠어요?")
            .bbangFont(.title1)
            .foregroundStyle(Color(.primaryNormal))
            .padding(.top, 41)
        
        // TODO: 카테고리명 Binding 변수로
        Text("삭제 시 카테고리 관련 데이터는 모두 삭제되며,\n삭제된 데이터는 복구가 불가능합니다.\n\n'\(categoryName)' 카테고리를 삭제할까요?")
            .bbangFont(.body2)
            .foregroundStyle(Color(.labelAlternative))
            .multilineTextAlignment(.center)
            .padding(.vertical, 60)
        
        buttons
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
    }
    
    var buttons: some View {
        HStack(spacing: 15) {
            Button("돌아가기") {
                isPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                    rightIcon: Image(.icBackward)
                )
            )
            
            Button("삭제하기") {
                onDelete()
                isPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary,
                    rightIcon: Image(.icTrash)
                )
            )
        }
    }
}
