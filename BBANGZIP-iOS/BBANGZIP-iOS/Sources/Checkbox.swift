//
//  Checkbox.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/13/25.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    var onToggle: (() -> Void)? = nil
    private var color: Color
    
    init(
        isChecked: Binding<Bool>,
        color: Color
    ) {
        self._isChecked = isChecked
        self.color = color
    }
    
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
    
    var body: some View {
        HStack {
            Checkbox(isChecked: $checked1, color: Color(.todored1))
            Checkbox(isChecked: $checked2, color: Color(.todored2))
             Checkbox(isChecked: $checked3, color: Color(.todoblue1))
             Checkbox(isChecked: $checked4, color: Color(.todoblue2))
        }
    }
}

#Preview {
    CheckboxPreviewContainer()
}
