//
//  TaskInputField.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/13/25.
//

import SwiftUI

public struct TaskInputField: View {
    @Binding public var text: String
    public let onCommit: (() -> Void)?
    
    public init(
        text: Binding<String>,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.onCommit = onCommit
    }
    
    public var body: some View {
        TextField(
            "할 일을 입력해주세요",
            text: $text,
            onCommit: {
            if isValidInput(text) {
                onCommit?()
            }
        })
        .bbangFont(.body1)
        .foregroundColor(Color(.labelNomal))
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(Color(.componentStrong))
        .cornerRadius(8)
    }
    
    private func isValidInput(_ input: String) -> Bool {
        return !input.isEmpty
    }
}
