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
            
            if viewModel.showImagePicker {
                imagePickerSheet
            }
            
            if viewModel.showNameInput {
                nameInputSheet
            }
        }
        .animation(.spring(response: 0.3), value: viewModel.showImagePicker)
        .animation(.spring(response: 0.3), value: viewModel.showNameInput)
        .ignoresSafeArea(edges: .bottom)
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
            
            if let selectedImage = viewModel.selectedProfileImage {
                Image(selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
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
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(
                        colors: [Color.blue, Color.pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: 36)
                
                HStack(spacing: 4) {
                    Text(viewModel.userName)
                        .bbangFont(.subtitle2)
                        .foregroundColor(Color(.staticwhite))
                    
                    if let selectedImage = viewModel.selectedProfileImage {
                        Image(selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 8)
            }
            .fixedSize()
            
            Spacer()
        }
        .padding(.leading, 20)
    }
    
    var namePlaceholderView: some View {
        Text("이름을 입력해주세요")
            .bbangFont(.body1)
            .foregroundColor(Color(.labelAssistive))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
    }
    
    var saveButton: some View {
        Button(action: {
            viewModel.saveProfile()
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
        .disabled(!viewModel.canSave)
        .padding(.horizontal, 20)
        .padding(.bottom, 56)
    }
    
    var imagePickerSheet: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showImagePicker = false
                }
            
            VStack {
                Spacer()
                ProfileImagePickerView(
                    viewModel: ProfileImagePickerViewModel(
                        currentImage: viewModel.selectedProfileImage,
                        onSave: { imageName in
                            viewModel.setProfileImage(imageName)
                        }
                    ),
                    isPresented: $viewModel.showImagePicker
                )
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    var nameInputSheet: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.showNameInput = false
                }
            
            VStack {
                Spacer()
                NameInputView(
                    viewModel: NameInputViewModel(
                        currentName: viewModel.userName,
                        currentProfileImage: viewModel.selectedProfileImage,
                        onSave: { name in
                            viewModel.setUserName(name)
                        }
                    ),
                    isPresented: $viewModel.showNameInput
                )
            }
            .transition(.move(edge: .bottom))
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    OnboardingView()
}
