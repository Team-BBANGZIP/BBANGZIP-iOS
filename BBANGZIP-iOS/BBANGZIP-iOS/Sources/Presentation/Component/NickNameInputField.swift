//
//  NickNameInputField.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/27/25.
//

import SwiftUI

public struct NickNameInputField: View {
    @Binding public var text: String
    @FocusState private var isFocused: Bool
    private let maxLength: Int = 20
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            TaskInputField(
                text: $text,
                placeholder: "이름을 입력해주세요"
            )
            .focused($isFocused)
            .onChange(of: text) { newValue in
                let filtered = newValue.replacingOccurrences(of: "\n", with: "")
                if filtered.count > maxLength {
                    text = String(filtered.prefix(maxLength))
                } else {
                    text = filtered
                }
            }
            
            HStack {
                Spacer()
                
                lengthCounter
            }
        }
    }
    
    var lengthCounter: some View {
        Text("\(text.count)/\(maxLength)")
            .bbangFont(.body3)
            .foregroundColor(Color(.labelAlternative))
    }
    
    private func isValidInput(_ input: String) -> Bool {
        return !input.isEmpty
    }
}

#Preview {
    PromiseInputField(text: .constant(""))
}
