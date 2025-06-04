//
//  CheckedOffView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct CheckedOffView: View {
    @StateObject private var viewModel: TimerCheckedOffViewModel
    
    init(viewModel: TimerCheckedOffViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            navBar
            titleSection
            scrollContent
            bottomButtons
        }
        .sheet(isPresented: $viewModel.isSheetPresented) {
            Text("카테고리 추가 시트")
            // TODO: 바텀시트 UI 구현 예정
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
                // TODO: 뒤로가기 구현
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
                ForEach(viewModel.categories) { category in
                    VStack(alignment: .leading, spacing: 0) {
                        CategoryButton(
                            color: .constant(category.color),
                            labelText: .constant(category.name),
                            isSheetPresented: $viewModel.isSheetPresented
                        )
                        .padding(.leading, 20)
                        
                        ForEach(category.todos) { todo in
                            TaskBox(
                                item: todo,
                                meatballTapped: {
                                    handleMeatballTapped(for: todo)
                                },
                                showSeperator: todo.id != category.todos.last?.id,
                                onToggleCompleted: {
                                    viewModel.toggleCompletion(for: category.id, todoId: todo.id)
                                }
                            )
                            .padding(.horizontal, 20)
                        }
                    }
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
                // TODO: 연장 기능 구현
            }
            .buttonStyle(BbangButtonStyle(style: .secondary, rightIcon: Image(.icPlusThick)))
            .frame(width: 140)
            
            Button("종료하기") {
                print("종료하기 버튼 눌림!!")
                // TODO: 종료 로직 구현
            }
            .buttonStyle(BbangButtonStyle(style: .primary, rightIcon: Image(.icQuit)))
        }
        .padding(.horizontal, 20)
    }
    
    func handleMeatballTapped(for todo: TimerTodo) {
        print("미트볼 버튼 눌림! - \(todo.content)")
        // TODO: 메뉴 또는 편집 기능 구현
    }
}

struct CheckedOffView_Previews: PreviewProvider {
    static var previews: some View {
        let previewData = [
            Category(
                id: 1,
                name: "오늘 할 일",
                color: Color(.todored1),
                todos: [
                    TimerTodo(
                        id: 101,
                        content: "할 일 1",
                        isCompleted: false,
                        startTime: "09:00",
                        color: Color(
                            .todored1
                        )
                    ),
                    TimerTodo(
                        id: 102,
                        content: "할 일 2",
                        isCompleted: true,
                        startTime: nil,
                        color: Color(.todored1)
                    )
                ]
            )
        ]
        
        let previewViewModel = TimerCheckedOffViewModel(previewCategories: previewData)
        
        return CheckedOffView(viewModel: previewViewModel)
    }
}
