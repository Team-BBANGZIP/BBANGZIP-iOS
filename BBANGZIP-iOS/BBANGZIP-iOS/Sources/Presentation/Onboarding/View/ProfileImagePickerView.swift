//
//  ProfileImagePickerView.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/26/25.
//

import SwiftUI

struct ProfileImagePickerView: View {
    @ObservedObject var viewModel: ProfileImagePickerViewModel
    @Binding var isPresented: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("프로필 이미지 설정")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelNormal))
                .padding(.bottom, 24)
                .padding(.top, 70)
            
            previewProfileImage
                .padding(.bottom, 32)
            
            profileImagesGrid
                .padding(.horizontal, 66)
            
            Spacer()
                .frame(height: 32)
            
            actionButtons
                .padding(.horizontal, 20)
                .padding(.bottom, 54)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 48)
                .fill(Color(.staticwhite))
        )
        .ignoresSafeArea()
    }
}

private extension ProfileImagePickerView {
    var previewProfileImage: some View {
        ZStack {
            Circle()
                .fill(Color(.backgroundStrong))
                .frame(width: 100, height: 100)
            
            let key = viewModel.tempSelectedKey ?? 0
            
            Image(key == 0 ? "icProfile" : "Profile_\(key)")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
        }
    }
    
    var profileImagesGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.selectableKeys, id: \.self) { key in
                profileImageButton(key)
            }
        }
    }
    
    func profileImageButton(_ key: Int) -> some View {
        Button {
            viewModel.selectImage(key)
        } label: {
            ZStack {
                Circle()
                    .fill(Color(.backgroundStrong))
                    .frame(width: 60, height: 60)
                
                Image(key == 0 ? "icProfile" : "Profile_\(key)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            }
        }
    }
    
    var actionButtons: some View {
        HStack(spacing: 15) {
            Button("취소") {
                viewModel.cancelSelection()
                isPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary,
                    rightIcon: Image(.icQuit)
                )
            )
            
            Button("저장하기") {
                viewModel.confirmSelection()
                isPresented = false
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                    rightIcon: Image(.icCheck)
                )
            )
        }
    }
}
