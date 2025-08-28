//
//  CategoryAddView.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/28/25.
//

import SwiftUI

struct CategoryAddView: View {
    @StateObject private var viewModel = CategoryAddViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @State private var showColorPicker = false
    
    private var isErrorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { newValue in if newValue == false { viewModel.clearError() } }
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HeaderBarView(
                    title: "카테고리 추가",
                    leftIcon: .icChevronLeft,
                    onTapLeft: { dismiss() },
                    rightTitle: "완료",
                    rightEnabled: viewModel.isCompleteButtonEnabled,
                    onTapRight: { viewModel.addCategory() }
                )
                
                VStack(spacing: 20) {
                    
                    UnderlineTextField(
                        text: $viewModel.categoryName,
                        placeholder: "카테고리명 입력",
                        isFocused: $isTextFieldFocused
                    )
                    .padding(.top, 8)
                    
                    ColorPickerRow(
                        selectedColor: viewModel.selectedColor,
                        onTap: {
                            isTextFieldFocused = false
                            showColorPicker = true
                        }
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 32)
            }
            .contentShape(Rectangle())
            .onTapGesture { isTextFieldFocused = false }
            .alert("오류", isPresented: isErrorPresented) {
                Button("확인", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onChange(of: viewModel.isCompleted) { isCompleted in
                if isCompleted { dismiss() }
            }
            .sheet(isPresented: $showColorPicker) {
                // TODO: 바텀시트 구현
                Text("바텀시트~")
                    .padding()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct HeaderBarView: View {
    let title: String
    let leftIcon: ImageResource
    let onTapLeft: () -> Void
    let rightTitle: String
    let rightEnabled: Bool
    let onTapRight: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onTapLeft) {
                Image(leftIcon)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
            }
            .foregroundStyle(Color(.labelAssistive))
            
            Spacer()
            
            Button(action: onTapRight) {
                Text(rightTitle)
                    .bbangFont(.body1)
            }
            .disabled(!rightEnabled)
            .foregroundStyle(rightEnabled ? Color(.labelNormal) : Color(.labelDisable))
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

private struct UnderlineTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .leading) {
                if text.isEmpty && !isFocused {
                    Text(placeholder)
                        .bbangFont(.body1)
                        .foregroundStyle(Color(.labelDisable))
                }
                TextField("", text: $text)
                    .bbangFont(.body1)
                    .foregroundStyle(Color(.labelNormal))
                    .focused($isFocused)
                    .submitLabel(.done)
                    .textInputAutocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.vertical, 8)
            .overlay(alignment: .bottom) {
                Capsule()
                    .fill(Color(.primaryNormal))
                    .frame(height: 2)
            }
        }
    }
}

private struct ColorPickerRow: View {
    let selectedColor: CategoryColor
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Button(action: onTap) {
                HStack(spacing: 8) {
                    Image(.icPalette)
                        .renderingMode(.template)
                        .foregroundStyle(Color(.labelAssistive))
                        .frame(width: 24, height: 24)
                    
                    Text("색상")
                        .bbangFont(.body2)
                        .foregroundStyle(Color(.labelAssistive))
                    
                    Spacer()
                    
                    Circle()
                        .fill(selectedColor.displayColor)
                        .frame(width: 24, height: 24)
                    
                    Image(.icChevronRight)
                        .renderingMode(.template)
                        .foregroundStyle(Color(.labelAssistive))
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CategoryAddView()
}
