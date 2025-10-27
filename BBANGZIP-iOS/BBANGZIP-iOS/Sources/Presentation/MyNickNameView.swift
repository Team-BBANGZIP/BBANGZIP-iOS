//
//  MyNickNameView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/27/25.
//

import SwiftUI

struct MyNickNameView: View {
    @State private var draft: String
    private let onSave: (String) -> Void
    
    init(
        initialText: String = "",
        onSave: @escaping (String) -> Void
    ) {
        _draft = State(initialValue: initialText)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("이름 설정하기")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 50)
            
            NickNameInputField(text: $draft)
                .padding(.horizontal, 20)
                .padding(.top, 31)
                .padding(.bottom, 28)
        }
        .onDisappear {
            let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
            onSave(trimmed)
        }
    }
}
