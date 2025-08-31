//
//  CategoryDeleteAlertView.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/31/25.
//

import SwiftUI

struct CategoryDeleteAlertView: View {
    var body: some View {
        Text("정말 삭제하시겠어요?")
            .bbangFont(.title1)
            .foregroundStyle(Color(.primaryNormal))
            .padding(.top, 41)
        
        // TODO: 카테고리명 Binding 변수로
        Text("삭제 시 카테고리 관련 데이터는 모두 삭제되며,\n삭제된 데이터는 복구가 불가능합니다.\n\n'WELCOME' 카테고리를 삭제할까요?")
            .bbangFont(.body2)
            .foregroundStyle(Color(.labelAlternative))
            .multilineTextAlignment(.center)
            .padding(.vertical, 60)
        
        buttons
            .padding(.horizontal, 18)
            .padding(.bottom, 12)
    }
    
    var buttons: some View {
        HStack(spacing: 8) {
            Button("돌아가기") {
                // TODO: 바텀 시트 내리기
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                    rightIcon: Image(.icBackward)
                )
            )
            
            Button("삭제하기") {
                // TODO: 카테고리 삭제하고 바텀 시트 내리기
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

#Preview {
    CategoryDeleteAlertView()
}
