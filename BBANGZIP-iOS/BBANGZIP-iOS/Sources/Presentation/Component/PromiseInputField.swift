//
//  PromiseInputField.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/1/25.
//

import SwiftUI

public struct PromiseInputField: View {
    @Binding public var text: String
    private let maxLength: Int = 50
    
    public init(text: Binding<String>
    ) {
        self._text = text
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .frame(minHeight: 90, maxHeight: 90)
                    .scrollContentBackground(.hidden)
                    .padding(12)
                    .lineSpacing(4)
                    .lineLimit(3)
                    .bbangFont(.body1)
                    .foregroundColor(Color(.labelNormal))
                    .background(Color(.componentStrong))
                    .tint(.clear)
                    .cornerRadius(8)
                    .keyboardType(.default)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .onChange(of: text) { newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
                
                if text.isEmpty {
                    Text("나만의 다짐을 적어보세요")
                        .foregroundColor(Color(.labelAssistive))
                        .bbangFont(.body1)
                        .padding(16)
                }
            }
            
            HStack {
                Spacer()
                
                Text("\(text.count)/\(maxLength)")
                    .bbangFont(.body3)
                    .foregroundColor(Color(.labelAlternative))
            }
        }
    }
    
    private func isValidInput(_ input: String) -> Bool {
        return !input.isEmpty
    }
}

#Preview {
    PromiseInputField(text: .constant(""))
}
