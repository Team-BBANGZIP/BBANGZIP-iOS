//
//  ToDoView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/27/25.
//

import SwiftUI

struct ToDoView: View {
    @StateObject private var viewModel: TodoViewModel
    @StateObject private var categoryListViewModel = CategoryListViewModel(
        repository: MockTodoRepository()
    )
    @State private var selectedDate: Date? = nil
    @State private var isShowMenu: Bool = false
    @State private var navigationPath = NavigationPath()
    
    init(
        viewModel: TodoViewModel,
        selectedDate: Date? = nil,
        isShowMenu: Bool = false
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.selectedDate = selectedDate
        self.isShowMenu = isShowMenu
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack(alignment: .topTrailing) {
                List {
                    VStack(spacing: 0) {
                        messageView
                        
                        VStack(spacing: 16) {
                            calendarHeaderView
                            calendarBodyView
                                .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 16)
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
                
                if isShowMenu {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isShowMenu = false
                            }
                        }
                    
                    CustomMenu(
                        onAddCategoryTapped: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isShowMenu = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                navigationPath.append("CategoryAdd")
                            }
                        },
                        onManageCategoryTapped: {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isShowMenu = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                navigationPath.append("CategoryList")
                            }
                        }
                    )
                    .padding(.top, 112)
                    .padding(.trailing, 20)
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "CategoryAdd" {
                    CategoryAddView(onDismiss: {
                        viewModel.fetchData()
                    })
                } else if destination == "CategoryList" {
                    CategoryListView(
                        viewModel: categoryListViewModel,
                        navigationPath: $navigationPath
                    )
                }
            }
            .navigationDestination(for: Category.self) { category in
                CategoryManageView(
                    category: category,
                    onSaved: { updated in
                        withAnimation(.spring()) {
                            categoryListViewModel.updateCategory(updated)
                        }
                        Task { await categoryListViewModel.persistCategory(updated) }
                    },
                    onDeleted: { id in
                        withAnimation(.spring()) {
                            categoryListViewModel.removeCategory(id: id)
                        }
                        Task { await categoryListViewModel.persistDeleteCategory(id: id) }
                    }
                )
            }
            .sheet(isPresented: $viewModel.isAddTodoSheetPresented) {
                let addViewModel = TaskAddViewModel { content, startTime in
                    viewModel.addTodo(content: content)
                }
                
                TaskAddView(
                    viewModel: addViewModel,
                    isPresented: $viewModel.isAddTodoSheetPresented
                )
                .presentationDetents([.height(190)])
                .presentationCornerRadius(48)
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $viewModel.isWriteMessageSheetPresented) {
                MyPromiseView()
                    .presentationDetents([.height(230)])
                    .presentationCornerRadius(48)
                    .presentationDragIndicator(.visible)
            }
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
        .onTapGesture {
            print("write")
            viewModel.isWriteMessageSheetPresented = true
        }
    }
    
    private var calendarHeaderView: some View {
        HStack(spacing: 20) {
            BbangText(
                viewModel.monthYearFormatter(date: viewModel.currentDate),
                font: .subtitle1,
                color: Color(.labelNeutral)
            )
            .padding(.leading, 20)
            .padding(.vertical, 6)
            
            Button(action: { viewModel.moveWeek(by: -1) }) {
                Image(.icChevronLeft)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Button(action: { viewModel.moveWeek(by: 1) }) {
                Image(.icChevronRight)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isShowMenu.toggle()
                }
            }) {
                Image(.icMenu)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
            }
            .buttonStyle(.plain)
            .padding(.trailing, 24)
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
                    viewModel.isAddTodoSheetPresented = true
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
                viewModel.moveTodoItems(from: fromOffsets, to: toOffset)
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
