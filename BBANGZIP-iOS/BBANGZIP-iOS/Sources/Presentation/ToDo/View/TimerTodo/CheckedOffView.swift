//
//  CheckedOffView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct CheckedOffView: View {
    @StateObject private var viewModel = CheckedOffViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            navBar
            titleSection
            scrollContent
            bottomButtons
        }
        .sheet(isPresented: $viewModel.isSheetPresented) {
            Text("카테고리 추가 시트")
            //TODO: 바텀시트 작업 필요
        }
        .navigationBarHidden(true)
    }
}

private extension CheckedOffView {
    
    var navBar: some View {
        HStack {
            Button(action: {
                //TODO: 뒤로가기 구현 뷰 연결
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
            .padding(.top, 30)
            .padding(.bottom, 30)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.leading, 20)
    }
    
    var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(
                    viewModel.categories.indices,
                    id: \.self
                ) { categoryIndex in
                    let category = viewModel.categories[categoryIndex]
                    
                    VStack(alignment: .leading, spacing: 0) {
                        CategoryButton(
                            color: $viewModel.categories[categoryIndex].color,
                            labelText: .constant(category.name),
                            isSheetPresented: $viewModel.isSheetPresented
                        )
                        .padding(.leading, 20)
                        
                        ForEach(
                            category.todos.indices,
                            id: \.self
                        ) { todoIndex in
                            let todo = category.todos[todoIndex]
                            let isLast = todoIndex == category.todos.count - 1
                            
                            TaskBox(
                                item: $viewModel.categories[categoryIndex].todos[todoIndex],
                                meatballTapped: {
                                    handleMeatballTapped(for: todo)
                                },
                                showSeperator: !isLast,
                                onToggleCompleted: { _ in }
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                Spacer(minLength: 50)
            }
        }
    }
    
    var bottomButtons: some View {
        HStack(spacing: 8) {
            Button("30분 더") {
                print("30분 뒤 버튼 눌림!")
                //TODO: 뷰 연결 필요
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
                //TODO: 뷰 연결 필요
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
    
    func handleMeatballTapped(for todo: TodoItem) {
        print("미트볼 버튼 눌림! - \(todo.content)")
        //TODO: 버튼 구현 필요
    }
}


struct CheckedOffView_Previews: PreviewProvider {
    static var previews: some View {
        CheckedOffView()
    }
}
