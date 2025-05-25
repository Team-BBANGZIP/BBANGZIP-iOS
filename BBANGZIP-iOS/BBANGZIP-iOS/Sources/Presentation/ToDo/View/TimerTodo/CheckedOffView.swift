//
//  CheckedOffView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/23/25.
//

import SwiftUI

struct CheckedOffView: View {
    @StateObject private var viewModel: CheckedOffViewModel
    
    init(viewModel: CheckedOffViewModel) {
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
            //TODO: 바텀시트 작업 필요
        }
        .navigationBarHidden(true)
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
                ForEach(
                    viewModel.categories,
                    id: \.categoryId
                ) { category in
                    VStack(alignment: .leading, spacing: 0) {
                        CategoryButton(
                            color: Binding(
                                get: {
                                    category.color
                                },
                                set: { _ in }
                            ),
                            labelText: .constant(category.name),
                            isSheetPresented: $viewModel.isSheetPresented
                        )
                        .padding(.leading, 20)
                        
                        if let todos = viewModel.todosByCategory[category.categoryId] {
                            ForEach(todos.indices, id: \.self) { index in
                                TaskBox(
                                    item: Binding(
                                        get: { viewModel.todosByCategory[category.categoryId]![index] },
                                        set: { viewModel.todosByCategory[category.categoryId]![index] = $0 }
                                    ),
                                    meatballTapped: {
                                        handleMeatballTapped(for: todos[index])
                                    },
                                    showSeperator: index < todos.count - 1,
                                    onToggleCompleted: { _ in }
                                )
                                .padding(.horizontal, 20)
                            }
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
        //TODO: 기능 구현 필요
    }
}

struct CheckedOffView_Previews: PreviewProvider {
    static var previews: some View {
        let categories = [
            Category(
                categoryId: 1,
                name: "제과제빵점",
                color: Color(
                    .todored1
                )
            ),
            Category(
                categoryId: 2,
                name: "스터디모임",
                color: Color(
                    .todogreen1
                )
            ),
            Category(
                categoryId: 3,
                name: "운동 루틴",
                color: Color(
                    .todoyellow1
                )
            ),
            Category(
                categoryId: 4,
                name: "사이드 프로젝트",
                color: Color(.todopurple1)
            )
        ]
        
        let todos: [Int: [TodoItem]] = [
            1: [
                TodoItem(
                    todoId: 11,
                    content: "Lo-Fi Wireframe 회의",
                    isCompleted: true,
                    startTime: "23:00",
                    color: Color(
                        .todored1
                    )
                ),
                TodoItem(
                    todoId: 12,
                    content: "Hi-Fi Wireframe 확정",
                    isCompleted: false,
                    startTime: "13:00",
                    color: Color(
                        .todored1
                    )
                )
            ],
            2: [
                TodoItem(
                    todoId: 21,
                    content: "영어 단어 복습",
                    isCompleted: false,
                    startTime: "07:00",
                    color: Color(
                        .todogreen1
                    )
                ),
                TodoItem(
                    todoId: 22,
                    content: "지난 주 발표 피드백",
                    isCompleted: true,
                    startTime: nil,
                    color: Color(
                        .todogreen1
                    )
                )
            ],
            3: [
                TodoItem(
                    todoId: 31,
                    content: "스쿼트 3세트",
                    isCompleted: false,
                    startTime: "06:30",
                    color: Color(
                        .todoyellow1
                    )
                ),
                TodoItem(
                    todoId: 32,
                    content: "스트레칭 10분",
                    isCompleted: false,
                    startTime: nil,
                    color: Color(
                        .todoyellow1
                    )
                )
            ],
            4: [
                TodoItem(
                    todoId: 41,
                    content: "Figma 디자인 리뷰",
                    isCompleted: true,
                    startTime: "22:00",
                    color: Color(
                        .todopurple1
                    )
                ),
                TodoItem(
                    todoId: 42,
                    content: "SwiftUI 리팩토링",
                    isCompleted: false,
                    startTime: nil,
                    color: Color(
                        .todopurple1
                    )
                ),
                TodoItem(
                    todoId: 43,
                    content: "README 문서 작성",
                    isCompleted: false,
                    startTime: "18:30",
                    color: Color(
                        .todopurple1
                    )
                )
            ]
        ]
        
        return CheckedOffView(
            viewModel: CheckedOffViewModel(
                categories: categories,
                todos: todos
            )
        )
    }
}
