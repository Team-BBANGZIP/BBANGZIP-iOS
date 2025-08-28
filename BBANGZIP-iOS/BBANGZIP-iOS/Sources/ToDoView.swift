//
//  ToDoView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/27/25.
//

import SwiftUI

struct ToDoView: View {
    var body: some View {
        VStack {
            messageView
                .frame(height: 60)
                .background(Color(.secondaryStrong))
        }
    }
    
    private var messageView: some View {
        HStack(spacing: 0) {
            BbangText(
                "나만의 다짐을 적어보세요",
                font: .body4,
                color: Color(.labelAlternative)
            )
            .padding(.leading, 20)
            
            Spacer()
            
            Image(.messageBread)
                .padding(.top, 13)
                .padding(.trailing, 19)
        }
    }
}

#Preview {
    ToDoView()
}
