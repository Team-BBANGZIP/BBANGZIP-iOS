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
    @State private var isColorPickerPresented = false
    
    var onDismiss: (() -> Void)?
    
    private var isErrorPresented: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { newValue in if newValue == false { viewModel.clearError() } }
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView(
                title: "카테고리 추가",
                leftIcon: .icChevronLeft,
                onTapLeft: {
                    isTextFieldFocused = false
                    onDismiss?()
                    dismiss()
                },
                
                rightTitle: "완료",
                rightEnabled: viewModel.isCompleteButtonEnabled,
                onTapRight: {
                    isTextFieldFocused = false
                    viewModel.addCategory()
                }
            )
            .navigationBarHidden(true)
            
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
                        isColorPickerPresented = true
                    }
                )
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)
        }
        .toolbar(.hidden, for: .tabBar)
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
        .alert("오류", isPresented: isErrorPresented) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .onChange(of: viewModel.isCompleted) { oldValue, newValue in
            if newValue {
                isTextFieldFocused = false
                onDismiss?()
                dismiss()
            }
        }
        .sheet(isPresented: $isColorPickerPresented) {
            PickColorView(selectedColor: $viewModel.selectedColor, isPresented: $isColorPickerPresented)
                .presentationDetents([.height(273)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
        }
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
                    .frame(width: 28, height: 28)
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
                    .onSubmit {
                        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            isFocused = false
                        }
                    }
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
                        .foregroundStyle(Color(.labelAlternative))
                        .frame(width: 24, height: 24)
                    
                    Text("색상")
                        .bbangFont(.body2)
                        .foregroundStyle(Color(.labelAlternative))
                    
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
