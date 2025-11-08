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
    @StateObject private var nameInputViewModel = NameInputViewModel(
        currentName: "",
        currentProfileImage: nil,
        onSave: { _ in }
    )
    
    var body: some View {
        ZStack {
            Color(.backgroundNomal)
                .ignoresSafeArea()
            
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
                    currentImage: viewModel.selectedProfileImage,
                    onSave: { imageName in
                        viewModel.setProfileImage(imageName)
                    }
                ),
                isPresented: $viewModel.showImagePicker
            )
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(48)
            .presentationDetents([.height(454)])
        }
        .sheet(isPresented: $viewModel.showNameInput) {
            NameInputView(
                viewModel: nameInputViewModel,
                isPresented: $viewModel.showNameInput
            )
            .presentationDetents([.height(151)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(48)
        }
        .alert("오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .onChange(of: viewModel.showNameInput) { oldValue, newValue in
            if oldValue && !newValue {
                viewModel.setUserName(nameInputViewModel.tempUserName)
            } else if !oldValue && newValue {
                nameInputViewModel.tempUserName = viewModel.userName
            }
        }
    }
}

private extension OnboardingView {
    var navigationBar: some View {
        HStack {
            Button(action: {
                dismiss()
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
        ZStack {
            Circle()
                .fill(Color(.backgroundStrong))
                .frame(width: 100, height: 100)
            
            Image(viewModel.selectedProfileImage ?? "profileBasic")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.openImagePicker()
                    }) {
                        Image(.profilePlus)
                    }
                }
            }
            .frame(width: 100, height: 100)
        }
    }
    
    var nameInputSection: some View {
        VStack(spacing: 0) {
            if viewModel.nameFilled {
                nameFilledView
            } else {
                namePlaceholderView
            }
            
            Rectangle()
                .fill(Color(.primaryNormal))
                .frame(height: 2)
                .padding(.horizontal, 20)
                .padding(.top, 10)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.openNameInput()
        }
    }
    
    var nameFilledView: some View {
        Text(viewModel.userName)
            .bbangFont(.body1)
            .foregroundColor(Color(.labelNormal))
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 20)
    }
    
    var namePlaceholderView: some View {
        Text("이름을 입력해주세요")
            .bbangFont(.body1)
            .foregroundColor(Color(.labelAssistive))
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 20)
    }
    
    var saveButton: some View {
        Button(action: {
            Task {
                await viewModel.saveProfile()
            }
        }) {
            HStack {
                Text("저장하기")
                    .bbangFont(.body2)
                    .foregroundColor(Color(.staticwhite))
                
                Image(.icPencil)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color(.staticwhite))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(viewModel.canSave ? Color(.primaryNormal) : Color(.disabled))
            )
        }
        .disabled(!viewModel.canSave || viewModel.isLoading)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

private struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
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

