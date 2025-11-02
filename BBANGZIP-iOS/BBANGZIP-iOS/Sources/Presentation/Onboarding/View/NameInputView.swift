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
                .frame(height: 300)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 48)
                .fill(Color(.backgroundNomal))
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTextFieldFocused = true
            }
        }
        .onDisappear {
            viewModel.confirmName()
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
                    viewModel.confirmName()
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
    
    func profileBadgePreview(_ imageName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [Color.blue, Color.pink],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(height: 36)
            
            HStack(spacing: 4) {
                Text(viewModel.tempUserName)
                    .bbangFont(.subtitle2)
                    .foregroundColor(Color(.staticwhite))
                    .lineLimit(1)
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
                    .clipShape(Circle())
            }
            .padding(.horizontal, 8)
        }
        .fixedSize()
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
