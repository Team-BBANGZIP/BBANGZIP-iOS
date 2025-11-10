//
//  CheckedOffView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct CheckedOffView: View {
    @StateObject private var viewModel: TimerCheckedOffViewModel
    let onBackToTimer: () -> Void
    let onStartAdditionalTimer: () -> Void
    
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
        .sheet(isPresented: $viewModel.isSheetPresented) {
            if let selectedCategory = viewModel.selectedCategory {
                let addViewModel = TodoAddViewModel(
                    addTodoUseCase: viewModel.addUseCase,
                    categoryId: selectedCategory.id,
                    targetDate: viewModel.currentTargetDate
                )

                TodoAddView(
                    viewModel: addViewModel,
                    isPresented: $viewModel.isSheetPresented
                )
                .presentationDetents([.height(190)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchData()
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
        }
        .scrollIndicators(.hidden)
    }
    
    var bottomButtons: some View {
        HStack(spacing: 8) {
            Button("30분 더") {
                print("30분 뒤 버튼 눌림!")
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
                print("종료하기 버튼 눌림!!")
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
                viewModel.selectedCategoryIndex = index
                viewModel.isSheetPresented = true
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
                handleMeatballTapped(for: todo)
            },
            showSeperator: showSeperator
        )
        .padding(.horizontal, 20)
    }
    
    func handleMeatballTapped(for todo: TimerTodo) {
        print("미트볼 버튼 눌림! - \(todo.content)")
        // TODO: 메뉴 또는 편집 기능 구현
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
