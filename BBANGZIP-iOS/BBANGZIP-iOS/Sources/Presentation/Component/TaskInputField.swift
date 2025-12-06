//
//  TaskInputField.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/13/25.
//

import SwiftUI

public struct TaskInputField: View {
    @Binding public var text: String
    public let placeholder: String
    public let onSubmit: (() -> Void)?
    
    public init(
        text: Binding<String>,
        placeholder: String = "할 일을 입력해주세요",
        onSubmit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(placeholder)
        )
        .tint(Color(.labelAssistive))
        .bbangFont(.body1)
        .foregroundColor(Color(.labelNormal))
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color(.componentStrong))
        .cornerRadius(8)
        .keyboardType(.default)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .onSubmit {
            if isValidInput(text) {
                onSubmit?()
            }
        }
    }
    
    private func isValidInput(_ input: String) -> Bool {
        return !input.isEmpty
    }
}
