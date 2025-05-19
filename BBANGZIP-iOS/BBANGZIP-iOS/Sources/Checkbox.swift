//
//  Checkbox.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/13/25.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    @Binding var color: Color
    var onToggle: (() -> Void)? = nil
    
    var body: some View {
        Button(action: {
            withAnimation(nil) {
                isChecked.toggle()
                onToggle?()
            }
        }) {
            ZStack {
                Image(.icBread)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(isChecked ? color : Color(.secondaryNormal))
                
                if isChecked {
                    Image(.icCheck)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(Color(.staticwhite))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

//TODO: 참고용 예시 코드
struct CheckboxPreviewContainer: View {
    @State var checked1 = false
    @State var checked2 = false
    @State var checked3 = false
    @State var checked4 = false
    @State var color1 = Color(.todored1)
    @State var color2 = Color(.todored2)
    @State var color3 = Color(.todoblue1)
    @State var color4 = Color(.todoblue2)
    
    var body: some View {
        HStack {
            Checkbox(isChecked: $checked1, color: $color1)
            Checkbox(isChecked: $checked2, color: $color2)
             Checkbox(isChecked: $checked3, color: $color3)
             Checkbox(isChecked: $checked4, color: $color4)
        }
    }
}

#Preview {
    CheckboxPreviewContainer()
}
