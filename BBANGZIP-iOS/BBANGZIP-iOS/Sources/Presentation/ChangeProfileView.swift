//
//  ChangeProfileView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 10/7/25.
//

import SwiftUI

struct ChangeProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ChangeProfileViewModel()
    @State private var profileImage: UIImage? = nil
    @State private var draft: String
    
    init(
        initialText: String = ""
    ) {
        _draft = State(initialValue: initialText)
    }
    
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack (spacing: 32) {
            HeaderBarView(
                title: "프로필 변경",
                leftIcon: .icChevronLeft,
                onTapLeft: {
                    onDismiss?()
                    dismiss()
                }
            )
            .navigationBarHidden(true)
            
            
            Button {
                print("사진 터치")
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    Group {
                        if let uiImage = profileImage {
                            Image(uiImage: uiImage)
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
                            "유나짱",
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
                    
                    PromiseInputField(text: $draft)
                        .disabled(true)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.isChangeNickNameSheetPresented) {
            MyNickNameView(
                initialText: "초기 텍스트입니다",
                onSave: { newText in
                    viewModel.updateNickName(newText)
                }
            )
            .presentationDetents([.height(230)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $viewModel.isMyPromiseSheetPresented) {
            MyPromiseView(
                initialText: "초기 텍스트입니다",
                onSave: { newText in
                    viewModel.updateMyPromiseMessage(newText)
                }
            )
            .presentationDetents([.height(230)])
            .presentationCornerRadius(48)
            .presentationDragIndicator(.visible)
        }
    }
}

private struct HeaderBarView: View {
    let title: String
    let leftIcon: ImageResource
    let onTapLeft: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTapLeft) {
                Image(leftIcon)
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

#Preview {
    ChangeProfileView()
}
