//
//  CategoryManageView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/2/25.
//

import SwiftUI

struct CategoryManageView: View {
    @StateObject private var viewModel: CategoryManageViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFieldFocused: Bool
    @State private var isColorPickerPresented = false
    @State private var isDeleteAlertPresented = false
    
    private let onSaved: (Category) -> Void
    
    init(category: Category, onSaved: @escaping (Category) -> Void) {
        self.onSaved = onSaved
        _viewModel = StateObject(
            wrappedValue: CategoryManageViewModel(
                category: category
            )
        )
    }
    
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
                    title: "카테고리 관리",
                    leftIcon: .icChevronLeft,
                    onTapLeft: { dismiss() },
                    rightTitle: "확인",
                    onTapRight: { viewModel.saveCategory() }
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
                            isColorPickerPresented = true
                        }
                    )
                    
                    StopToggleRow(isStopped: $viewModel.isStopped)
                    
                    Spacer()
                    
                    DeleteButton {
                        isDeleteAlertPresented = true
                    }
                    .padding(.horizontal, 20)
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
                if isCompleted {
                    let updated = viewModel.updateCategory()
                    onSaved(updated)
                    dismiss()
                }
            }
            .sheet(isPresented: $isColorPickerPresented) {
                if #available(iOS 16.4, *) {
                    PickColorView(selectedColor: $viewModel.selectedColor, isPresented: $isColorPickerPresented)
                        .presentationDetents([.height(273)])
                        .presentationCornerRadius(48)
                        .presentationDragIndicator(.visible)
                } else {
                    PickColorView(selectedColor: $viewModel.selectedColor, isPresented: $isColorPickerPresented)
                        .presentationDetents([.height(273)])
                        .presentationDragIndicator(.visible)
                }
            }
            .sheet(isPresented: $isDeleteAlertPresented) {
                if #available(iOS 16.4, *) {
                    CategoryDeleteAlertView()
                        .presentationDetents([.height(364)])
                        .presentationCornerRadius(48)
                        .presentationDragIndicator(.visible)
                } else {
                    CategoryDeleteAlertView()
                        .presentationDetents([.height(364)])
                        .presentationDragIndicator(.visible)
                }
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
            .foregroundStyle(Color(.labelNormal))
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
                HStack(spacing: 4) {
                    Image(.icPalette)
                        .renderingMode(.template)
                        .foregroundStyle(Color(.labelAlternative))
                        .frame(width: 24, height: 24)
                    
                    Text("색상")
                        .bbangFont(.body2)
                        .foregroundStyle(Color(.labelAlternative))
                        .padding(.leading, 4)
                    
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

private struct StopToggleRow: View {
    @Binding var isStopped: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(.icEye)
                    .renderingMode(.template)
                    .foregroundStyle(Color(.labelAlternative))
                    .frame(width: 24, height: 24)
                
                Text("그만하기")
                    .bbangFont(.body2)
                    .foregroundStyle(Color(.labelAlternative))
                
                Spacer()
                
                Toggle("", isOn: $isStopped)
                    .toggleStyle(SwitchToggleStyle(tint: Color(.primaryNormal)))
                    .labelsHidden()
                    .scaleEffect(0.8)
            }
            
            HStack {
                Text("기존 데이터는 보존되지만,\n종료 시점 이후 새로운 할 일을 추가할 수 없어요")
                    .bbangFont(.label4)
                    .foregroundStyle(Color(.labelAssistive))
                    .padding(.leading, 32)
                
                Spacer()
            }
        }
    }
}

private struct DeleteButton: View {
    var onTap: () -> Void
    
    var body: some View {
        Button("삭제하기") {
            onTap()
        }
        .buttonStyle(
            BbangButtonStyle(
                style: .secondary,
                leftIcon: Image(.icTrash)
            )
        )
    }
}
