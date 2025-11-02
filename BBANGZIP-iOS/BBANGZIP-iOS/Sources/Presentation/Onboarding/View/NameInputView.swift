//
//  NameInputView.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

struct NameInputView: View {
    @ObservedObject var viewModel: NameInputViewModel
    @Binding var isPresented: Bool
    @FocusState private var isTextFieldFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State private var isDismissing = false
    
    var body: some View {
        VStack(spacing: 0) {
            handleBar
                .padding(.top, 12)
                .padding(.bottom, 20)
            
            Text("이름 설정하기")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelNormal))
                .padding(.bottom, 30)
            
            nameInputSection
                .padding(.horizontal, 20)
            
            Spacer()
                .frame(height: keyboardHeight + 28)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.backgroundNomal))
        .clipShape(.rect(
            topLeadingRadius: 48,
            topTrailingRadius: 48
        ))
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            isTextFieldFocused = true
        }
        .onDisappear {
            viewModel.confirmName()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardHeight = keyboardFrame.height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            if !isDismissing {
                self.keyboardHeight = 0
            }
        }
    }
}

private extension NameInputView {
    var handleBar: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(Color(.labelDisable))
            .frame(width: 60, height: 5)
    }
    
    var nameInputSection: some View {
        VStack(spacing: 8) {
            TaskInputField(
                text: $viewModel.tempUserName,
                placeholder: "이름을 입력해주세요",
                onSubmit: {
                    isDismissing = true
                    viewModel.confirmName()
                    isPresented = false
                }
            )
            .focused($isTextFieldFocused)
            .onChange(of: viewModel.tempUserName) { oldValue, newValue in
                viewModel.validateNameInput(newValue)
            }
            
            HStack {
                Spacer()
                characterCounter
            }
        }
    }
    
    var characterCounter: some View {
        Text("\(viewModel.nameCount)/\(viewModel.maxNameLength)")
            .bbangFont(.body3)
            .foregroundStyle(Color(.labelAlternative))
    }
}

#Preview {
    @Previewable @State var isPresented = true
    
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            NameInputView(
                viewModel: NameInputViewModel(
                    currentName: "",
                    currentProfileImage: "profile_character_1",
                    onSave: { _ in }
                ),
                isPresented: $isPresented
            )
        }
    }
}
