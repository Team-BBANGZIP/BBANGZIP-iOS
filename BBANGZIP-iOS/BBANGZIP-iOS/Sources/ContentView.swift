import SwiftUI

public struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel(
        timerUseCase: TimerUseCaseImpl(),
        breadCountUseCase: BreadCountUseCaseImpl(repository: BreadCountRepositoryImpl())
    )
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var wasPausedByLock = false
    @State private var showCheckedOffView = false
    @State private var isLaunch: Bool = true
    
    public init() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(Color(.componentAlternative))
        appearance.shadowColor = UIColor(Color(.labelDisable))
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(.labelAssistive))
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    public var body: some View {
        if isLaunch {
            LaunchView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.isLaunch = false
                        }
                    }
                }
        } else {
            ZStack {
                if showCheckedOffView {
                    checkedOffView
                        .transition(.move(edge: .trailing))
                } else {
                    mainTabView
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showCheckedOffView)
            .onChange(of: scenePhase) { newPhase in
                handleScenePhaseChange(newPhase)
            }
            .onChange(of: timerViewModel.state) { newState in
                handleTimerStateChange(newState)
            }
            .onReceive(timerViewModel.$shouldShowCheckedOffView) { shouldShow in
                if shouldShow {
                    showCheckedOffView = true
                    timerViewModel.resetCheckedOffViewFlag()
                }
            }
        }
    }
    
    
    private var mainTabView: some View {
        TabView {
            TimerView(viewModel: timerViewModel)
                .tabItem {
                    Image(.icTimer)
                        .renderingMode(.template)
                    Text("빵굽기")
                }
            
            ToDoView(viewModel: makeTodoViewModel())
                .tabItem {
                    Image(.icBook)
                        .renderingMode(.template)
                    Text("할 일")
                }
            
            Text("이웃")
                .tabItem {
                    Image(.icChat)
                        .renderingMode(.template)
                    Text("이웃")
                }
            
            MyPageView()
                .tabItem {
                    Image(.icPerson)
                        .renderingMode(.template)
                    Text("마이")
                }
        }
        .accentColor(Color(.staticblack))
        .toolbarBackground(
            Color(.componentAlternative),
            for: .tabBar
        )
    }
    
    
    private var checkedOffView: some View {
        let mockRepo = MockTodoRepository()
        let fetchUseCase = DefaultFetchTimerTodosUseCase(repository: mockRepo)
        let toggleUseCase = TimerToggleTodoCompletionUseCase(todoRepository: mockRepo)
        let addUseCase = DefaultAddTodoUseCase(repository: mockRepo)
        
        let checkedOffViewModel = TimerCheckedOffViewModel(
            fetchUseCase: fetchUseCase,
            toggleUseCase: toggleUseCase,
            addUseCase: addUseCase
        )
        
        return CheckedOffView(
            viewModel: checkedOffViewModel,
            onBackToTimer: {
                showCheckedOffView = false
                timerViewModel.resetToInitial()
            },
            onStartAdditionalTimer: {
                showCheckedOffView = false
                timerViewModel.startAdditionalTimer()
            }
        )
    }
    
    private func makeTodoViewModel() -> TodoViewModel {
        let repo = MockTodoRepository()
        let fetchUseCase = DefaultFetchTimerTodosUseCase(repository: repo)
        let toggleUseCase = TimerToggleTodoCompletionUseCase(todoRepository: repo)
        let addUseCase = DefaultAddTodoUseCase(repository: repo)
        return TodoViewModel(
            fetchUseCase: fetchUseCase,
            toggleUseCase: toggleUseCase,
            addUseCase: addUseCase
        )
    }
    
    
    private func handleScenePhaseChange(_ phase: ScenePhase) {
        switch phase {
        case .active:
            if wasPausedByLock {
                wasPausedByLock = false
            }
        case .inactive:
            if timerViewModel.state == .running {
                timerViewModel.pauseForLock()
                wasPausedByLock = true
            }
        case .background:
            break
        @unknown default:
            break
        }
    }
    
    private func handleTimerStateChange(_ state: TimerViewModel.TimerState) {
        switch state {
        case .running:
            UIApplication.shared.isIdleTimerDisabled = true
        case .initial, .done:
            UIApplication.shared.isIdleTimerDisabled = false
            wasPausedByLock = false
        case .paused:
            UIApplication.shared.isIdleTimerDisabled = false
        @unknown default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
