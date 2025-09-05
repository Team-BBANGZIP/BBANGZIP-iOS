//
//  CustomMenu.swift
//  BBANGZIP
//
//  Created by 최유빈 on 9/4/25.
//

import SwiftUI

struct CustomMenu: View {
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                print("카테고리 추가")
            } label: {
                HStack(spacing: 8) {
                    Image(.icPlusThin)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(.labelNormal))
                    
                    BbangText(
                        "카테고리 추가",
                        font: .body3,
                        color: Color(.labelNormal)
                    )
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 4)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray)
                .padding(.horizontal, 8)
                .opacity(0.3)
            
            Button {
                print("카테고리 관리")
            } label: {
                HStack(spacing: 8) {
                    Image(.icPencil)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color(.labelNormal))
                    
                    BbangText(
                        "카테고리 관리",
                        font: .body3,
                        color: Color(.labelNormal)
                    )
                }
            }
            .buttonStyle(.plain)
            .padding(.bottom, 4)
        }
        .frame(width: 125, height: 84)
        .background(Color(.backgroundNomal))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: Color(.backgroundDimmer).opacity(0.12),
            radius: 12,
            x: 0,
            y: 2
        )
        
    }
}

#Preview {
    CustomMenu()
}
