//
//  PickColorView.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/31/25.
//

import SwiftUI

struct PickColorView: View {
    @Binding var selectedColor: CategoryColor
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0){
            Text("카테고리 색상")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 25)
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 16),
                    count: 5
                ),
                spacing: 20
            ) {
                ForEach(CategoryColor.allCases, id: \.self) { colorCase in
                    Circle()
                        .fill(Color(colorCase.rawValue))
                        .frame(width: 48, height: 48)
                        .onTapGesture {
                            selectedColor = colorCase
                            isPresented = false
                        }
                }
            }
            .padding(.horizontal, 36)
            .padding(.top, 31)
            .padding(.bottom, 40)
        }
    }
}
