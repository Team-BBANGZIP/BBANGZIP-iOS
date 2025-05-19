//
//  CategoryButton.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/15/25.
//

import SwiftUI

struct CategoryButton: View {
    @Binding var color: Color
    @Binding var labelText: String
    @Binding var isSheetPresented: Bool
    
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

//TODO: 참고용 예시 코드
struct CategoryPreviewContainer: View {
    @State var label1 = "빵집"
    @State var label2 = "밥집"
    @State var color1 = Color(.todored1)
    @State var color2 = Color(.todoblue1)
    @State var isSheetPresented1 = false
    @State var isSheetPresented2 = false
    
    var body: some View {
        HStack {
            CategoryButton(
                color: $color1,
                labelText: $label1,
                isSheetPresented: $isSheetPresented1
            )
            .sheet(isPresented: $isSheetPresented1) {
                Text(label1 + "에 어서오세요")
                    .presentationDetents([.medium])
            }
            
            CategoryButton(
                color: $color2,
                labelText: $label2,
                isSheetPresented: $isSheetPresented2
            )
            .sheet(isPresented: $isSheetPresented2) {
                Text(label2 + "에 어서오세요")
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    CategoryPreviewContainer()
}
