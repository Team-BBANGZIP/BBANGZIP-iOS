//
//  OnboardingView.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isNameFieldFocused: Bool

    var body: some View {
        ZStack {
            Color(.backgroundNomal)
                .ignoresSafeArea()
                .onTapGesture {
                    isNameFieldFocused = false
                }

            VStack(spacing: 0) {
                navigationBar

                Spacer()
                    .frame(height: 50)

                profileImageSection

                Spacer()
                    .frame(height: 48)

                nameInputSection

                Spacer()

                saveButton
            }

            if viewModel.isLoading {
                LoadingView()
            }
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ProfileImagePickerView(
                viewModel: ProfileImagePickerViewModel(
                    currentKey: viewModel.selectedProfileImageKey,
                    onSave: { key in
                        viewModel.setProfileImage(key)
                    }
                ),
                isPresented: $viewModel.showImagePicker
            )
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(48)
            .presentationDetents([.height(454)])
        }
        .alert(
            "오류",
            isPresented: .constant(viewModel.errorMessage != nil)
        ) {
            Button("확인") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .onChange(of: viewModel.userName) { _, newValue in
            viewModel.validateNameInput(newValue)
        }
    }
}

private extension OnboardingView {
    var navigationBar: some View {
        HStack {
            Button(action: {
                NotificationCenter.default.post(
                    name: NSNotification.Name("OnboardingDismissed"),
                    object: nil
                )
            }) {
                Image(.icChevronLeft)
                    .foregroundColor(Color(.labelAlternative))
                    .frame(width: 24, height: 24)
            }

            Spacer()

            Text("프로필 설정")
                .bbangFont(.title2)
                .foregroundColor(Color(.labelStrong))

            Spacer()

            Image(.icChevronLeft)
                .frame(width: 24, height: 24)
                .opacity(0)
        }
        .padding(.horizontal, 16)
        .padding(.top, 17.5)
    }

    var profileImageSection: some View {
        Button(action: {
            viewModel.openImagePicker()
        }) {
            ZStack {
                Circle()
                    .fill(Color(.backgroundStrong))
                    .frame(width: 100, height: 100)

                Image(
                    (viewModel.selectedProfileImageKey ?? 0) == 0
                    ? "ic_profile"
                    : "Profile_\(viewModel.selectedProfileImageKey!)"
                )
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(.profilePlus)
                    }
                }
                .frame(width: 100, height: 100)
            }
        }
        .contentShape(Circle())
    }

    var nameInputSection: some View {
        VStack(spacing: 0) {
            TextField(
                "",
                text: $viewModel.userName,
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
                Text("\(viewModel.userName.count)/\(viewModel.maxNameLength)")
                    .bbangFont(.body3)
                    .foregroundStyle(Color(.labelAlternative))
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)
        }
    }

    var saveButton: some View {
        Button(action: {
            Task {
                await viewModel.saveProfile()
            }
        }) {
            Text("저장하기")
        }
        .buttonStyle(
            BbangButtonStyle(
                style: viewModel.canSave ? .secondary : .disabled,
                rightIcon: Image(.icCheck)
            )
        )
        .disabled(!viewModel.canSave || viewModel.isLoading)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

private struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}

#Preview {
    OnboardingView()
}
