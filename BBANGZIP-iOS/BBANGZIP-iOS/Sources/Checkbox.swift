//
//  Checkbox.swift
//  BBANGZIP
//
//  Created by 김송희 on 5/13/25.
//

import SwiftUI

struct Checkbox: View {
    @State private var isChecked: Bool = false
    
    var body: some View {
        Button(action: {
            withAnimation(nil) {
                isChecked.toggle()
            }
        }) {
            ZStack {
                Image(.icBread)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 19, height: 19)
                    .foregroundColor(isChecked ? Color(.todored1) : Color(.secondaryNormal))
                
                if isChecked {
                    Image(.icCheck)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 9, height: 9)
                        .foregroundColor(Color(.staticwhite))
                }
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    Checkbox()
}
