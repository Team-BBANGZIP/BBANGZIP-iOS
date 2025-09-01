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
            
            scrollContent
                .padding(.top, 8)
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
    
    // MARK: - 상단 메시지
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
    
    // MARK: - 캘린더 헤더
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
    
    // MARK: - 캘린더 바디
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
    
    // MARK: - 요약
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

    // MARK: - 목록 (indices 기반 + 자연 드래그)
    var scrollContent: some View {
        List {
            if let cats = viewModel.todoData?.categories {
                ForEach(cats.indices, id: \.self) { cIndex in
                    let category = cats[cIndex]
                    categorySection(for: category, at: cIndex)
                }
            }
            Spacer(minLength: 50)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .moveDisabled(true) // 스페이서는 이동 불가, 그대로 유지
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .environment(\.defaultMinListRowHeight, 0)
        .contentShape(Rectangle())
    }

    // MARK: - 섹션 (카테고리 고정 + Todo 자연 드래그-드롭)
    // 동일 섹션 내 재정렬만 가능
    @ViewBuilder
    func categorySection(for category: Category, at cIndex: Int) -> some View {
        Section {
            // 카테고리 버튼(고정) - 변경 없음, 이동 불가 설정 추가
            CategoryButton(
                color: .constant(category.colorType.color),
                labelText: .constant(category.name)
            )
            .onTapGesture {
                viewModel.selectedCategoryIndex = cIndex
                viewModel.isSheetPresented = true
            }
            .padding(.leading, 20)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .moveDisabled(true) // NEW: 카테고리 헤더는 이동 불가로 고정

            // 행은 id 기반 ForEach - .onMove로 드래그앤드롭 활성화
            ForEach(category.todos, id: \.id) { todo in
                let isLast = (todo.id == category.todos.last?.id)
                let todoViewModel = viewModel.makeTodoViewModel(todo: todo)
                TaskBox(
                    viewModel: todoViewModel,
                    meatballTapped: { handleMeatballTapped(for: todo) },
                    showSeperator: !isLast
                )
                .padding(.horizontal, 20)
                .buttonStyle(PlainButtonStyle())
                .asTodoListRow(isLast: isLast) // 기존 스타일 헬퍼 유지
            }
            .onMove { fromOffsets, toOffset in // NEW: 시스템 드래그앤드롭, 아이템 벌어짐 애니메이션 포함
                withAnimation(.easeInOut) {
                    viewModel.moveTodos(inCategoryAt: cIndex, from: fromOffsets, to: toOffset)
                }
            }

            // 섹션 맨 아래 투명 드롭 영역(선택) - 섹션 끝 드롭을 위해 유지
            Rectangle()
                .fill(Color.clear)
                .frame(height: 12)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .dropDestination(for: String.self) { items, _ in // CHANGED: .onMove가 주로 처리, 이건 끝 드롭 보장용
                    guard let idStr = items.first, let draggingID = Int(idStr),
                          let cats = viewModel.todoData?.categories,
                          cats.indices.contains(cIndex) else { return false }
                    let todos = cats[cIndex].todos
                    guard let from = todos.firstIndex(where: { $0.id == draggingID }) else { return false }
                    let to = todos.count
                    if from != to - 1 {
                        withAnimation(.easeInOut) {
                            viewModel.moveTodos(inCategoryAt: cIndex, from: IndexSet(integer: from), to: to)
                        }
                    }
                    return true
                }
        }
    }

    // MARK: - 행 뷰
    func todoRow(for todo: TimerTodo, in category: Category, categoryIndex: Int, showSeperator: Bool) -> some View {
        let todoViewModel = viewModel.makeTodoViewModel(todo: todo)
        return TaskBox(
            viewModel: todoViewModel,
            meatballTapped: { handleMeatballTapped(for: todo) },
            showSeperator: showSeperator
        )
        .padding(.horizontal, 20)
        .buttonStyle(PlainButtonStyle())
    }

    func handleMeatballTapped(for todo: TimerTodo) {
        print("미트볼 버튼 눌림! - \(todo.content)")
    }
}

// MARK: - 공통 modifier 헬퍼
private extension View {
    func asTodoListRow(isLast: Bool) -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .contentShape(Rectangle())
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
