//
//  CategoryButton.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/15/25.
//

import SwiftUI

struct CategoryButton: View {
    private var color: Color
    private var labelText: String
    private var action: () -> Void
    
    init(
        color: Color,
        labelText: String,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.labelText = labelText
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 14, height: 14)
                
                Text(labelText)
                    .bbangFont(.label3)
                    .foregroundColor(Color(.labelStrong))
                
                Image(.icPlusThick)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(Color(.labelAlternative))
                    .frame(width: 18, height: 18)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color(.secondaryLight))
            .cornerRadius(32)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CategoryButton(
            color: Color(.todored1),
            labelText: "빵집",
            action: {
                print("어서오세요 빵집입니다")
            }
        )
        CategoryButton(
            color: Color(.todoblue1),
            labelText: "밥집",
            action: {
                print("어서오세요 밥집입니다")
            }
        )
        CategoryButton(
            color: Color(.todogreen1),
            labelText: "술집",
            action: {
                print("어서오세요 술집입니다")
            }
        )
    }
}
