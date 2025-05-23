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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Button(action: {
                        // TODO: 뒤로가기 구현 예정
                    }) {
                        Image(.icChevronLeft)
                            .foregroundColor(Color(.labelAlternative))
                            .padding(.leading, 16)
                    }
                    Spacer()
                }
                .padding(.top, 15)
                
                Text("어떤 할 일을 완료하셨나요?")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(.darkGray))
                    .padding(.leading, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                
                ForEach(viewModel.categories.indices, id: \.self) { categoryIndex in
                    let category = viewModel.categories[categoryIndex]
                    
                    VStack(alignment: .leading, spacing: 0) {
                        CategoryButton(
                            color: $viewModel.categories[categoryIndex].color,
                            labelText: .constant(category.name),
                            isSheetPresented: $viewModel.isSheetPresented
                        )
                        .padding(.leading, 20)
                        
                        ForEach(category.todos.indices, id: \.self) { todoIndex in
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
        .sheet(isPresented: $viewModel.isSheetPresented) {
            Text("카테고리 수정 시트")
        }
        .navigationBarHidden(true)
    }
    
    private func handleMeatballTapped(for todo: TodoItem) {
        print("미트볼 버튼 눌림! - \(todo.content)")
        // TODO: 미트볼 열리는거 구현해야 함
    }
}

struct CheckedOffView_Previews: PreviewProvider {
    static var previews: some View {
        CheckedOffView()
    }
}
