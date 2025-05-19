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
