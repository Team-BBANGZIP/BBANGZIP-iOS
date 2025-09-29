//
//  TodoContentEditView.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/28/25.
//

import SwiftUI

struct TodoContentEditView: View {
    @StateObject var viewModel: TodoContentEditViewModel
    @Binding var isPresented: Bool
    
    init(
        originalTodo: String,
        isPresented: Binding<Bool>,
        onSave: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: TodoContentEditViewModel(
                onEditTodo: onSave,
                originalTodo: originalTodo
            )
        )
        self._isPresented = isPresented
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("할 일 수정")
                .bbangFont(.title3)
                .foregroundStyle(Color(.labelAlternative))
                .padding(.top, 25)
            
            TaskInputField(text: $viewModel.newTodo) {
                viewModel.editTodoTitle()
                isPresented = false
            }
            .padding(.top, 31)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 20)
        .onDisappear {
            viewModel.editTodoTitle()
        }
    }
}

