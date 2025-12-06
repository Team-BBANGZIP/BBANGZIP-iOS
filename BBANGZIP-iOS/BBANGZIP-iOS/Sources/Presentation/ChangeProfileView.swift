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
    
    var onDismiss: (() -> Void)?
    
    init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: ChangeProfileViewModel(getProfileUseCase: GetProfileUseCaseImpl(repository: ProfileRepository()), updateProfileUseCase: DefaultUpdateProfileUseCase(repository: ProfileRepository())))
    }
    
    var body: some View {
        VStack (spacing: 32) {
            HeaderBarView(
                title: "프로필 변경",
                onTapLeft: {
                    onDismiss?()
                    dismiss()
                }
            )
            .navigationBarHidden(true)
            
            
            Button {
                viewModel.showChangeProfileImageSheet()
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let selected = viewModel.selectedProfileImage {
                            Image(selected)
                                .resizable()
                        } else if let url = URL(string: viewModel.profileImageUrl) {
                            KFImage(url)
                                .resizable()
                        } else {
                            Image(.icProfile)
                                .resizable()
                        }
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    ZStack {
                        Circle()
                            .fill(Color(.labelDisable))
                            .frame(width: 24, height: 24)
                            .padding(2)
                            .overlay(Circle().stroke(Color(.backgroundNomal), lineWidth: 2))
                        
                        Image(.icPlusThick)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .offset(x: 2, y: 1)
                }
            }
            
            HStack {
                BbangText(
                    "이름",
                    font: .title2,
                    color: Color(.labelStrong)
                )
                
                Spacer()
                
                Button {
                    viewModel.showChangeNickNameSheet()
                } label: {
                    HStack(spacing: 8) {
                        BbangText(
                            viewModel.nickname,
                            font: .title2,
                            color: Color(.labelStrong)
                        )
                        
                        Image(.icChevronRight)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(.trailing, 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .frame(height: 32)
            
            
            Button {
                viewModel.showMyPromiseSheet()
            } label: {
                VStack(spacing: 20) {
                    HStack {
                        BbangText(
                            "상태 메세지",
                            font: .title2,
                            color: Color(.labelStrong)
                        )
                        
                        Spacer()
                        
                        Image(.icChevronRight)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 4)
                    }
                    .frame(height: 32)
                    
                    PromiseInputField(text: $viewModel.commitmentMessage)
                        .disabled(true)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Spacer()
        }
        .sheet(
            isPresented: $viewModel.isChangeNickNameSheetPresented
        ) {
            MyNickNameView(
                initialText: viewModel.nickname,
                onSave: { newText in
                    viewModel.updateNickName(newText)
                }
            )
            .presentationDetents([.height(230)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }
        .sheet(
            isPresented: $viewModel.isMyPromiseSheetPresented
        ) {
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
