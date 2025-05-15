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
    @Binding var isSheetPresented: Bool
    
    init(
        color: Color,
        labelText: String,
        isSheetPresented: Binding<Bool>
    ) {
        self.color = color
        self.labelText = labelText
        self._isSheetPresented = isSheetPresented
    }
    
    var body: some View {
        Button(action: {
            isSheetPresented = true
        }) {
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
