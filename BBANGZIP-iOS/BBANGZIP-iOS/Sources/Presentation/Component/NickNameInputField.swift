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
    private let maxLength: Int = 50
    
    public init(text: Binding<String>) {
        self._text = text
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topLeading) {
                textField
                    .focused($isFocused)
                
                if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    placeholder
                }
            }
            
            HStack {
                Spacer()
                
                lengthCounter
            }
        }
    }
    
    var textField: some View {
        TextEditor(text: $text)
            .frame(minHeight: 90, maxHeight: 90)
            .scrollContentBackground(.hidden)
            .padding(12)
            .lineSpacing(4)
            .bbangFont(.body1)
            .foregroundColor(Color(.labelNormal))
            .background(Color(.componentStrong))
            .cornerRadius(8)
            .keyboardType(.default)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .onChange(of: text) { newValue in
                let filtered = newValue.replacingOccurrences(of: "\n", with: "")
                if filtered.count > maxLength {
                    text = String(filtered.prefix(maxLength))
                } else {
                    text = filtered
                }
            }
    }
    
    var placeholder: some View {
        Text("이름을 입력해주세요")
            .foregroundStyle(Color(.labelAssistive))
            .bbangFont(.body1)
            .padding(16)
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
