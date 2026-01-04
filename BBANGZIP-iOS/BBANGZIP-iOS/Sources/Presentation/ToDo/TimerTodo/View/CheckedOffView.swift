//
//  CheckedOffView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import Combine
import SwiftUI

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow: AnyPublisher<CGFloat, Never> =
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .eraseToAnyPublisher()
        
        let willHide: AnyPublisher<CGFloat, Never> =
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .eraseToAnyPublisher()
        
        return willShow
            .merge(with: willHide)
            .eraseToAnyPublisher()
    }
}

struct CheckedOffView: View {
    @StateObject private var viewModel: TimerCheckedOffViewModel
    let onBackToTimer: () -> Void
    let onStartAdditionalTimer: () -> Void
    
    @State private var keyboardHeight: CGFloat = 0
    
    enum SheetType: Identifiable {
        case addTodo(Category)
        case editTodo(TimerTodo)
        
        var id: String {
            switch self {
            case .addTodo(let category):
                return "add_\(category.id)"
            case .editTodo(let todo):
                return "edit_\(todo.id)"
            }
        }
    }
    
    @State private var activeSheet: SheetType? = nil
    
    init(
        viewModel: TimerCheckedOffViewModel,
        onBackToTimer: @escaping () -> Void,
        onStartAdditionalTimer: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBackToTimer = onBackToTimer
        self.onStartAdditionalTimer = onStartAdditionalTimer
    }
    
    var body: some View {
        VStack(spacing: 0) {
            navBar
            titleSection
            scrollContent
            bottomButtons
        }
        .sheet(item: $activeSheet) { sheetType in
            switch sheetType {
            case .addTodo(let category):
                let addDetentHeight: CGFloat = keyboardHeight > 0 ? 170 : 190
                let addViewModel = TodoAddViewModel(
                    addTodoUseCase: viewModel.addUseCase,
                    categoryId: category.id,
                    targetDate: viewModel.currentTargetDate
                )
                
                TodoAddView(
                    viewModel: addViewModel,
                    isPresented: Binding(
                        get: { activeSheet != nil },
                        set: { if !$0 { activeSheet = nil } }
                    )
                )
                .presentationDetents([.height(addDetentHeight)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
                
            case .editTodo(let todo):
                let detentHeight: CGFloat = keyboardHeight > 0 ? 145 : 151
                
                TodoContentEditView(
                    originalTodo: todo.content,
                    isPresented: Binding(
                        get: { activeSheet != nil },
                        set: { if !$0 { activeSheet = nil } }
                    ),
                    onSave: { newContent in
                        try await viewModel.updateTodoContent(
                            todoId: todo.id,
                            newContent: newContent
                        )
                    }
                )
                .ignoresSafeArea(.keyboard)
                .presentationDetents([.height(detentHeight)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchData()
        }
        .onReceive(Publishers.keyboardHeight) { h in
            withAnimation(.easeOut(duration: 0.2)) {
                keyboardHeight = h
            }
        }
    }
}

private extension CheckedOffView {
    
    var navBar: some View {
        HStack {
            Button(action: {
                onBackToTimer()
            }) {
                Image(.icChevronLeft)
                    .foregroundColor(Color(.labelAlternative))
                    .padding(.leading, 16)
            }
            Spacer()
        }
        .padding(.top, 11)
    }
    
    var titleSection: some View {
        Text("어떤 할 일을 완료하셨나요?")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(Color(.darkGray))
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
    }
    
    var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(
                    Array(viewModel.categories.enumerated()),
                    id: \.element.id
                ) { index, category in
                    categorySection(
                        for: category,
                        at: index
                    )
                }
                Spacer(minLength: 50)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
    }
    
    var bottomButtons: some View {
        HStack(spacing: 8) {
            Button("30분 더") {
                onStartAdditionalTimer()
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .secondary,
                    rightIcon: Image(.icPlusThick)
                )
            )
            .frame(width: 140)
            
            Button("종료하기") {
                onBackToTimer()
            }
            .buttonStyle(
                BbangButtonStyle(
                    style: .primary,
                    rightIcon: Image(.icQuit)
                )
            )
        }
        .padding(.horizontal, 20)
    }
    
    func categorySection(
        for category: Category,
        at index: Int
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            CategoryButton(
                color: .constant(category.colorType.color),
                labelText: .constant(category.name)
            )
            .onTapGesture {
                activeSheet = .addTodo(category)
            }
            .padding(.leading, 20)
            
            ForEach(category.todos) { todo in
                let isLast = todo.id == category.todos.last?.id
                todoRow(
                    for: todo,
                    showSeperator: !isLast
                )
            }
        }
    }
    
    func todoRow(
        for todo: TimerTodo,
        showSeperator: Bool
    ) -> some View {
        let todoViewModel = viewModel.makeTodoViewModel(todo: todo)
        
        return TaskBox(
            viewModel: todoViewModel,
            meatballTapped: {
                activeSheet = .editTodo(todo)
            },
            showSeperator: showSeperator
        )
        .padding(.horizontal, 20)
    }
}

extension CategoryColor {
    var color: Color {
        switch self {
        case .Todored1:
            return Color(.todored1)
        case .Todoyellow1:
            return Color(.todoyellow1)
        case .Todogreen1:
            return Color(.todogreen1)
        case .Todoblue1:
            return Color(.todoblue1)
        case .Todopurple1:
            return Color(.todopurple1)
        case .Todored2:
            return Color(.todored2)
        case .Todoyellow2:
            return Color(.todoyellow2)
        case .Todogreen2:
            return Color(.todogreen2)
        case .Todoblue2:
            return Color(.todoblue2)
        case .Todopurple2:
            return Color(.todopurple2)
        }
    }
}
