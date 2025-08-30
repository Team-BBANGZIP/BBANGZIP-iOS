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
            
            scrollContent
            
            Spacer()
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
    
    private var messageView: some View {
        ZStack {
            Color(.secondaryStrong)
            
            HStack(spacing: 0) {
                BbangText(
                    "나만의 다짐을 적어보세요",
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
            
            Button(action: {}) {
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
    
    var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let categories = viewModel.todoData?.categories {
                    ForEach(Array(categories.enumerated()), id: \.element.id) { index, category in
                        categorySection(for: category, at: index)
                    }
                }

                Spacer(minLength: 50)
            }
        }
        .scrollIndicators(.hidden)
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
