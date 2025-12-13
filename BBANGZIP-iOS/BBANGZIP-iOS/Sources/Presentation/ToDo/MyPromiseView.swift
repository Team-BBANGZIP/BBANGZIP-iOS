//
//  MyPromiseView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/1/25.
//

import SwiftUI

struct MyPromiseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var draft: String
    @FocusState private var isTextFieldFocused: Bool
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
            
            PromiseInputField(
                text: $draft,
                onSubmit: {
                    let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    onSave(trimmed)
                    dismiss()
                }
            )
            .focused($isTextFieldFocused)
            .padding(.horizontal, 20)
            .padding(.top, 31)
            .padding(.bottom, 28)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isTextFieldFocused = true
            }
        }
        .onDisappear {
            if !isTextFieldFocused {
                let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                onSave(trimmed)
            }
        }
    }
}
