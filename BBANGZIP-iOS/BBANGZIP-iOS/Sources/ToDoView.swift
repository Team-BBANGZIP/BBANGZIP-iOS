//
//  ToDoView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/27/25.
//

import SwiftUI

struct ToDoView: View {
    @StateObject private var viewModel: TodoViewModel
    @State private var selectedDate: Date? = nil
    
    init(viewModel: TodoViewModel, selectedDate: Date? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.selectedDate = selectedDate
    }
    
    var body: some View {
        List {
            // 상단 메시지 + 캘린더 + 요약
            VStack(spacing: 0) {
                messageView
                
                VStack(spacing: 16) {
                    calendarHeaderView
                    calendarBodyView
                        .padding(.horizontal, 20)
                }
                .padding(.vertical, 12)
                .background(Color(.secondaryLight))
                
                todoSummaryView
                    .padding(.trailing, 20)
                    .padding(.top, 20)
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            
            TodoContentView
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .environment(\.defaultMinListRowHeight, 0)
        .onAppear {
            viewModel.fetchData()
        }
    }

    
    private var messageView: some View {
        ZStack {
            Color(.secondaryStrong)
            HStack(spacing: 0) {
                BbangText(
                    "\(viewModel.todoData?.commitmentMessage ?? "나만의 다짐을 적어보세요")",
                    font: .body4,
                    color: Color(.labelAlternative)
                )
                .padding(.leading, 20)
                
                Spacer()
                
                Image(.messageBread)
                    .padding(.top, 13)
                    .padding(.trailing, 19)
            }
        }
        .frame(height: 60)
    }
    
    private var calendarHeaderView: some View {
        HStack(spacing: 20) {
            BbangText(
                viewModel.monthYearFormatter(date: viewModel.currentDate),
                font: .subtitle1,
                color: Color(.labelNeutral)
            )
            .padding(.leading, 20)
            
            Button(action: { viewModel.moveWeek(by: -1) }) {
                Image(.icChevronLeft)
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
            }
            
            Button(action: { viewModel.moveWeek(by: 1) }) {
                Image(.icChevronRight)
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
            }
            
            Spacer()
            
            Menu {
                Button {
                    print("카테고리 추가")
                } label: {
                    HStack(spacing: 8) {
                        Image(.icPlusThin)
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(.labelNormal))
                        BbangText("카테고리 추가", font: .body2, color: Color(.labelNormal))
                    }
                }
                
                Divider().frame(width: 109, height: 1)
                
                Button {
                    print("카테고리 관리")
                } label: {
                    HStack(spacing: 8) {
                        Image(.icPencil)
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(.labelNormal))
                        BbangText("카테고리 관리", font: .body2, color: Color(.labelNormal))
                    }
                }
            } label: {
                Image(.icMenu)
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundStyle(Color(.labelAlternative))
            }
            .padding(.trailing, 20)
        }
    }
    
    private var calendarBodyView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(viewModel.daysOfWeek.indices, id: \.self) { index in
                let day = viewModel.daysOfWeek[index]
                if let date = viewModel.calculateDateForDay(day) {
                    CalendarCellView(
                        day: day,
                        date: date,
                        selectedDate: $selectedDate
                    )
                }
            }
        }
    }
    
    var todoSummaryView: some View {
        HStack(spacing: 1.5) {
            Spacer()
            
            ZStack {
                Image(.icBread)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(.labelAlternative))
                
                Image(.icCheck)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(Color(.componentAlternative))
            }
            
            BbangText(
                "\(viewModel.todoData?.summary.completedCount ?? 0) / \(viewModel.todoData?.summary.totalCount ?? 0)",
                font: .body4,
                color: Color(.labelAlternative)
            )
        }
    }

    var TodoContentView: some View {
        ForEach(viewModel.todoItems, id: \.stableID) { item in
            if let (category, index) = item.asCategory {
                CategoryButton(
                    color: .constant(category.colorType.color),
                    labelText: .constant(category.name)
                )
                .padding(.leading, 20)
                .padding(.top, 16)
                .onTapGesture {
                    viewModel.selectedCategoryIndex = index
                    viewModel.isSheetPresented = true
                }
                .moveDisabled(true)
                
            } else if let todo = item.asTodo {
                let todoVM = viewModel.makeTodoViewModel(todo: todo)
                TaskBox(
                    viewModel: todoVM,
                    meatballTapped: { handleMeatballTapped(for: todo) },
                    showSeperator: true
                )
                .padding(.horizontal, 20)
                .buttonStyle(PlainButtonStyle())
                
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(minHeight: 4)
                    .padding(.horizontal, 20)
            }
        }
        .onMove { fromOffsets, toOffset in
            withAnimation(.easeInOut) {
                viewModel.moveFlatItems(from: fromOffsets, to: toOffset)
            }
        }
    }

    func handleMeatballTapped(for todo: TimerTodo) {
        print("미트볼 버튼 눌림! - \(todo.content)")
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        let mockRepo = MockTodoRepository()
        let fetchUseCase = DefaultFetchTimerTodosUseCase(repository: mockRepo)
        let toggleUseCase = TimerToggleTodoCompletionUseCase(todoRepository: mockRepo)
        
        let previewViewModel = TodoViewModel(
            fetchUseCase: fetchUseCase,
            toggleUseCase: toggleUseCase,
            addUseCase: DefaultAddTodoUseCase(repository: mockRepo)
        )

        return ToDoView(viewModel: previewViewModel)
    }
}
