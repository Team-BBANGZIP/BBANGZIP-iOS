//
//  MyPromiseView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/1/25.
//

import SwiftUI

struct MyPromiseView: View {
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
            Text("나만의 다짐 작성")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 50)
            
            PromiseInputField(text: $draft)
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
