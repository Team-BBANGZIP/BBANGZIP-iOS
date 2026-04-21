//
//  ToDoView.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/27/25.
//

import SwiftUI

struct ToDoView: View {
    private let repository = TodoRepositoryImpl()
    var onNavigationDepthChanged: ((Bool) -> Void)? = nil
    
    @StateObject private var viewModel: TodoViewModel
    @StateObject private var categoryListViewModel: CategoryListViewModel
    @State private var addTodoViewModel: TodoAddViewModel? = nil
    @State private var selectedDate: Date? = nil
    @State private var isShowMenu: Bool = false
    @State private var navigationPath = NavigationPath() {
        didSet {
            onNavigationDepthChanged?(!navigationPath.isEmpty)
        }
    }
    
    @State private var dragOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    @State private var calendarWidth: CGFloat = 0
    
    init(
        viewModel: TodoViewModel,
        selectedDate: Date? = nil,
        isShowMenu: Bool = false,
        onNavigationDepthChanged: ((Bool) -> Void)? = nil
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.selectedDate = selectedDate
        self.isShowMenu = isShowMenu
        
        let categoryFetchRepository = CategoryFetchRepositoryImpl()
        let fetchCategoriesUseCase = FetchCategoriesUseCaseImpl(
            repository: categoryFetchRepository
        )
        _categoryListViewModel = StateObject(
            wrappedValue: CategoryListViewModel(
                fetchCategoriesUseCase: fetchCategoriesUseCase
            )
        )
        self.onNavigationDepthChanged = onNavigationDepthChanged
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
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
                                .frame(height: 17)
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
                        selectedDate = nil
                        viewModel.resetToToday()
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
                .sheet(
                    isPresented: $viewModel.isAddTodoSheetPresented,
                    onDismiss: {
                        addTodoViewModel = nil
                    },
                    content: {
                        if let vm = addTodoViewModel {
                            TodoAddView(
                                viewModel: vm,
                                isPresented: $viewModel.isAddTodoSheetPresented,
                                onSuccess: {
                                    viewModel.fetchData()
                                    viewModel.isAddTodoSheetPresented = false
                                }
                            )
                            .presentationDetents([.height(190)])
                            .presentationCornerRadius(48)
                            .presentationDragIndicator(.visible)
                        }
                    }
                )
                .sheet(isPresented: $viewModel.isMyPromiseSheetPresented) {
                    MyPromiseView(
                        initialText: viewModel.todoData?.myPromiseMessage ?? "",
                        onSave: { newText in
                            viewModel.updateMyPromiseMessage(newText)
                        }
                    )
                    .presentationDetents([.height(230)])
                    .presentationCornerRadius(48)
                    .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $viewModel.isMeatballSheetPresented) {
                    let id = viewModel.sheetTodoId
                    
                    let titleBinding = Binding<String>(
                        get: { viewModel.todoDataTitle(for: id) ?? viewModel.sheetTodoTitle },
                        set: { new in
                            viewModel.updateTodoTitle(id: id, newTitle: new)
                        }
                    )
                    
                    let startTimeBinding = Binding<String?>(
                        get: { viewModel.todoDataStartTime(for: id) ?? viewModel.sheetStartTime },
                        set: { new in
                            viewModel.updateTodoStartTime(id: id, newTime: new)
                        }
                    )
                    
                    let initialTargetDate = viewModel.todoDataTargetDate(for: id)
                    ?? viewModel.currentTargetDate
                    
                    TodoManageView(
                        viewModel: TodoManageViewModel(
                            title: titleBinding,
                            category: viewModel.sheetCategoryName,
                            startTime: startTimeBinding,
                            isAlerted: $viewModel.sheetIsAlerted,
                            isCompleted: viewModel.sheetIsCompleted,
                            todoId: id,
                            repository: repository,
                            repeatTodoUseCase: DefaultRepeatTodoUseCase(repository: TodoRepositoryImpl()),
                            copyTodoUseCase: DefaultCopyTodoUseCase(repository: TodoRepositoryImpl()),
                            initialTargetDate: initialTargetDate,
                            onDelete: {
                            },
                            onPostpone: {},
                            onDuplicate: { [weak viewModel] in
                                viewModel?.fetchData()
                                viewModel?.isMeatballSheetPresented = false
                            },
                            onChangeDate: {
                                viewModel.isMeatballSheetPresented = false
                            },
                            onPatchedTitle: { [weak viewModel] _ in
                                viewModel?.fetchData()
                            },
                            onDeleted: {
                                id,
                                newCompleted,
                                newTotal in
                                viewModel.removeTodo(
                                    id: id,
                                    newCompleted: newCompleted,
                                    newTotal: newTotal
                                )
                                viewModel.isMeatballSheetPresented = false
                            },
                            onPatchedStartTime: { id, newHHmm in
                                viewModel.replaceTodoStartTime(id: id, newStartTime: newHHmm)
                            }
                        )
                    )
                }
            }
            
            Spacer()
                .frame(height: 28)
        }
        .onChange(of: navigationPath.count) { _, count in
            onNavigationDepthChanged?(count > 0)
        }
    }
    
    private var messageView: some View {
        ZStack {
            Color(.secondaryStrong)
            HStack(spacing: 0) {
                BbangText(
                    "\(viewModel.todoData?.myPromiseMessage ?? "나만의 다짐을 적어보세요")",
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
            viewModel.isMyPromiseSheetPresented = true
        }
    }
    
    private var calendarHeaderView: some View {
        HStack(spacing: 20) {
            BbangText(
                viewModel.monthYearFormatter(date: viewModel.currentDate),
                font: .subtitle1,
                color: Color(.labelNeutral)
            )
            .frame(width: 77, alignment: .leading)
            .padding(.leading, 20)
            .padding(.vertical, 6)
            
            Button(action: {
                guard !isAnimating else { return }
                isAnimating = true
                withAnimation(.easeOut(duration: 0.25)) {
                    dragOffset = calendarWidth
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    viewModel.moveWeek(by: -1)
                    dragOffset = 0
                    isAnimating = false
                }
            }) {
                Image(.icChevronLeft)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color(.labelAlternative))
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Button(action: {
                guard !isAnimating else { return }
                isAnimating = true
                withAnimation(.easeOut(duration: 0.25)) {
                    dragOffset = -calendarWidth
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    viewModel.moveWeek(by: 1)
                    dragOffset = 0
                    isAnimating = false
                }
            }) {
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
        GeometryReader { geometry in
            let width = geometry.size.width
            
            HStack(spacing: 0) {
                weekGridView(offsetWeeks: -1)
                    .frame(width: width)
                weekGridView(offsetWeeks: 0)
                    .frame(width: width)
                weekGridView(offsetWeeks: 1)
                    .frame(width: width)
            }
            .frame(width: width * 3, alignment: .leading)
            .offset(x: -width + dragOffset)
            .clipped()
            .onAppear { calendarWidth = width }  // 추가
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isAnimating else { return }
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        guard !isAnimating else { return }
                        let threshold = width * 0.3
                        
                        if value.translation.width < -threshold {
                            isAnimating = true
                            withAnimation(.easeOut(duration: 0.25)) {
                                dragOffset = -width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                viewModel.moveWeek(by: 1)
                                dragOffset = 0
                                isAnimating = false
                            }
                        } else if value.translation.width > threshold {
                            isAnimating = true
                            withAnimation(.easeOut(duration: 0.25)) {
                                dragOffset = width
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                viewModel.moveWeek(by: -1)
                                dragOffset = 0
                                isAnimating = false
                            }
                        } else {
                            withAnimation(.easeOut(duration: 0.2)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .frame(height: 70)
    }

    private func weekGridView(offsetWeeks: Int) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(Array(viewModel.daysOfWeek.enumerated()), id: \.offset) { index, day in
                if let date = viewModel.calculateDate(for: day, offsetWeeks: offsetWeeks) {
                    let selectedDateBinding = Binding<Date?>(
                        get: { selectedDate },
                        set: { new in
                            selectedDate = new
                            viewModel.setSelectedDate(new ?? viewModel.currentDate)
                        }
                    )
                    CalendarCellView(
                        day: day,
                        date: date,
                        selectedDate: selectedDateBinding
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
                .padding(.top, 8)
                .onTapGesture {
                    viewModel.selectedCategoryIndex = index
                    addTodoViewModel = viewModel.makeAddTodoViewModel()
                    viewModel.isAddTodoSheetPresented = true
                }
                .moveDisabled(true)
                
            } else if let todo = item.asTodo {
                let todoVM = viewModel.makeTodoViewModel(todo: todo)
                
                if let currentIndex = viewModel.todoItems.firstIndex(where: { $0.id == item.id }) {
                    
                    let nextItem = viewModel.todoItems[safe: currentIndex + 1]
                    let isLastInCategory = {
                        if case .tailDropZone = nextItem {
                            return true
                        }
                        return false
                    }()
                    
                    TaskBox(
                        viewModel: todoVM,
                        meatballTapped: { viewModel.presentMeatball(for: todo) },
                        showSeperator: !isLastInCategory
                    )
                    .padding(.horizontal, 20)
                    .buttonStyle(PlainButtonStyle())
                }
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
}
