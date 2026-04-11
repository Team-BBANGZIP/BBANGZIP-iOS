//
//  ChangeProfileView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/7/25.
//

import SwiftUI
import Kingfisher

struct ChangeProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ChangeProfileViewModel
    @FocusState private var isNameFieldFocused: Bool
    @State private var isNameFocused: Bool = false
    
    let maxNameLength: Int = 20
    var onDismiss: (() -> Void)?
    
    init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: ChangeProfileViewModel(
            getProfileUseCase: GetProfileUseCaseImpl(repository: ProfileRepository()),
            updateProfileUseCase: DefaultUpdateProfileUseCase(repository: ProfileRepository())
        ))
    }
    
    var body: some View {
        ZStack {
            Color(.backgroundNomal)
                .ignoresSafeArea()
                .onTapGesture {
                    isNameFieldFocused = false
                }
            
            VStack(spacing: 0) {
                HeaderBarView(
                    title: "프로필 수정",
                    onTapLeft: {
                        onDismiss?()
                        dismiss()
                    }
                )
                .navigationBarHidden(true)
                
                Spacer().frame(height: 24)
                
                profileImageSection
                
                Spacer().frame(height: 32)
                
                nameInputSection
                
                Spacer().frame(height: 32)
                
                promiseSection
                
                Spacer()
                
                saveButton
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.isChangeProfileImageSheetPresented) {
            ProfileImagePickerView(
                viewModel: ProfileImagePickerViewModel(
                    currentImage: viewModel.selectedProfileImage,
                    onSave: { imageName in
                        viewModel.updateMyProfileImage(imageName)
                    }
                ),
                isPresented: $viewModel.isChangeProfileImageSheetPresented
            )
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(48)
            .presentationDetents([.height(454)])
        }
        .sheet(isPresented: $viewModel.isMyPromiseSheetPresented) {
            MyPromiseView(
                initialText: viewModel.commitmentMessage,
                onSave: { newText in
                    viewModel.updateMyPromiseMessage(newText)
                }
            )
            .presentationDetents([.height(230)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }
        .onChange(of: isNameFieldFocused) { _, newValue in
            isNameFocused = newValue
        }
        .onChange(of: viewModel.nickname) { _, newValue in
            validateNameInput(newValue)
        }
    }
    
    private var profileImageSection: some View {
        Button {
            viewModel.showChangeProfileImageSheet()
        } label: {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let selected = viewModel.selectedProfileImage {
                        Image(selected).resizable()
                    } else if !viewModel.profileImageUrl.isEmpty,
                              let url = URL(string: viewModel.profileImageUrl) {
                        KFImage(url)
                            .resizable()
                            .placeholder { Image(.icProfile).resizable() }
                            .cacheOriginalImage()
                            .id(viewModel.profileImageUrl)
                    } else {
                        Image(.icProfile).resizable()
                    }
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                ZStack {
                    Circle()
                        .fill(Color(.labelDisable))
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color(.backgroundNomal), lineWidth: 2))
                    
                    Image(.icPlusThick)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .offset(x: 2, y: 1)
            }
        }
    }
    
    private var nameInputSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("이름")
                .bbangFont(.title3)
                .foregroundColor(Color(.labelNeutral))
                .padding(.horizontal, 20)
            
            Spacer().frame(height: 20)
            
            TextField(
                "",
                text: $viewModel.nickname,
                prompt: Text("이름을 입력해주세요")
                    .foregroundColor(Color(.labelAssistive))
            )
            .bbangFont(.body1)
            .foregroundColor(Color(.labelNormal))
            .focused($isNameFieldFocused)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding(.horizontal, 20)
            
            Rectangle()
                .fill(Color(.primaryNormal))
                .frame(height: 2)
                .padding(.horizontal, 20)
                .padding(.top, 10)
            
            HStack {
                Spacer()
                Text("\(viewModel.nickname.count)/\(maxNameLength)")
                    .bbangFont(.body3)
                    .foregroundStyle(isNameFocused ? Color(.labelAlternative) : Color(.labelAssistive))
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }
    
    private var promiseSection: some View {
        Button {
            isNameFieldFocused = false
            viewModel.showMyPromiseSheet()
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                Text("나만의 다짐")
                    .bbangFont(.title3)
                    .foregroundColor(Color(.labelNeutral))
                
                Text(viewModel.commitmentMessage)
                    .bbangFont(.body1)
                    .foregroundColor(Color(.labelNormal))
                    .multilineTextAlignment(.leading)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.componentStrong))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
    }
        
    private var saveButton: some View {
        Button(action: {
            isNameFieldFocused = false
            viewModel.saveProfile()
            onDismiss?()
            dismiss()
        }) {
            Text("저장하기")
        }
        .buttonStyle(
            BbangButtonStyle(
                style: !viewModel.nickname.isEmpty ? .secondary : .disabled,
                rightIcon: Image(.icCheck)
            )
        )
        .disabled(viewModel.nickname.isEmpty)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    // MARK: - Validation
    
    private func validateNameInput(_ newValue: String) {
        if newValue.count > maxNameLength {
            viewModel.nickname = String(newValue.prefix(maxNameLength))
            return
        }
        if containsEmoji(newValue) {
            viewModel.nickname = removeEmojis(from: newValue)
        }
    }
    
    private func containsEmoji(_ text: String) -> Bool {
        for scalar in text.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                0x1F300...0x1F5FF,
                0x1F680...0x1F6FF,
                0x2600...0x26FF,
                0x2700...0x27BF,
                0x1F900...0x1F9FF,
                0x1FA70...0x1FAFF,
                0x1F1E6...0x1F1FF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    private func removeEmojis(from text: String) -> String {
        text.unicodeScalars.filter {
            switch $0.value {
            case 0x1F600...0x1F64F,
                0x1F300...0x1F5FF,
                0x1F680...0x1F6FF,
                0x2600...0x26FF,
                0x2700...0x27BF,
                0x1F900...0x1F9FF,
                0x1FA70...0x1FAFF,
                0x1F1E6...0x1F1FF:
                return false
            default:
                return true
            }
        }
        .map(String.init)
        .joined()
    }
}

private struct HeaderBarView: View {
    let title: String
    let onTapLeft: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTapLeft) {
                Image(.icChevronLeft)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 28, height: 28)
            }
            .foregroundStyle(Color(.labelAssistive))
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .overlay {
            Text(title)
                .bbangFont(.title2)
                .foregroundStyle(Color(.labelNormal))
                .allowsHitTesting(false)
        }
    }
}
