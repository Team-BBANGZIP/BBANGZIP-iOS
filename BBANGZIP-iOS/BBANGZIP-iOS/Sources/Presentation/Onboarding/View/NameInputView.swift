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
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 33)
            
            Text("이름 설정하기")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelNormal))
                .padding(.bottom, 30)
                .offset(y: keyboardHeight > 0 ? -10 : 0)
            
            nameInputSection
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.backgroundNomal))
        .offset(y: keyboardHeight > 0 ? +10 : 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
    }
}

private extension NameInputView {
    var nameInputSection: some View {
        VStack(spacing: 8) {
            TaskInputField(
                text: $viewModel.tempUserName,
                placeholder: "이름을 입력해주세요",
                onSubmit: {
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
            .foregroundStyle(Color(.labelAssistive))
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
