//
//  MenuBox.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/5/25.
//

import SwiftUI

struct MenuBox: View {
    let menu: String
    let onMenuTapped: () -> Void
    
    var body: some View {
        Button{
            onMenuTapped()
        } label: { 
            HStack {
                BbangText(
                    menu,
                    font: .body2,
                    color: Color(.labelNormal)
                )
                
                Spacer()
                
                Image(.icChevronRight)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAssistive))
            }
            .frame(height: 44)
        }
    }
}
