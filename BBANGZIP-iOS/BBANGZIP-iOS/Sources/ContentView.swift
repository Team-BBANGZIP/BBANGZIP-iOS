import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

public struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel(
        timerUseCase: TimerUseCaseImpl(),
        breadCountUseCase: BreadCountUseCaseImpl(repository: BreadCountRepositoryImpl()),
        timerCompleteUseCase: DefaultTimerCompleteUseCase(repository: TimerCompleteRepository())
    )
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var wasPausedByLock = false
    @State private var showCheckedOffView = false
    @State private var isLaunch: Bool = true
    @State private var isLoggedIn: Bool = false
    @State private var showOnboarding: Bool = false
    
    @State private var selectedTab: Int = 0
    
    public init() {
        KakaoSDK.initSDK(appKey: ConfigManager.kakaoAppKey)
//TODO: 기존 기본 탭바 사용 시 주석 해제
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = UIColor(Color(.componentAlternative))
//        appearance.shadowColor = UIColor(Color(.labelDisable))
//        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(.labelAssistive))
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    public var body: some View {
        Group {
            if isLaunch {
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                checkAuthStatusAndNavigate()
                            }
                        }
                    }
            } else if showOnboarding {
                OnboardingView()
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OnboardingCompleted"))) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.showOnboarding = false
                            self.isLoggedIn = true
                        }
                    }
//TODO: 로그인 반영 후 수정
//            } else if !isLoggedIn {
//                LoginView()
//                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LoginSuccess"))) { _ in
//                        withAnimation(.easeInOut(duration: 0.3)) {
//                            self.isLoggedIn = true
//                        }
//                    }
//                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowOnboarding"))) { _ in
//                        withAnimation(.easeInOut(duration: 0.3)) {
//                            self.showOnboarding = true
//                        }
//                    }
//                    .onOpenURL { url in
//                        if AuthApi.isKakaoTalkLoginUrl(url) {
//                            _ = AuthController.handleOpenUrl(url: url)
//                        }
//                    }
            } else {
                mainContent
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("AuthenticationFailed"))) { _ in
            handleAuthenticationFailure()
        }
    }
    
    private func checkAuthStatusAndNavigate() {
        let hasToken = TokenManager.shared.hasValidTokens()
        
        self.isLaunch = false
        
        if hasToken {
            self.isLoggedIn = true
        } else {
            self.isLoggedIn = false
        }
    }
    
    private func handleAuthenticationFailure() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if timerViewModel.state == .running {
                timerViewModel.pauseForLock()
            }
            timerViewModel.resetToInitial()
            
            showCheckedOffView = false
            wasPausedByLock = false
            UIApplication.shared.isIdleTimerDisabled = false
            
            isLoggedIn = false
        }
    }
    
    private var mainContent: some View {
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
        .onChange(of: scenePhase) { oldPhase, newPhase in
            handleScenePhaseChange(newPhase)
        }
        .onChange(of: timerViewModel.state) { oldState, newState in
            handleTimerStateChange(newState)
        }
        .onReceive(timerViewModel.$shouldShowCheckedOffView) { shouldShow in
            if shouldShow {
                showCheckedOffView = true
                timerViewModel.resetCheckedOffViewFlag()
            }
        }
    }

// TODO: 기존 기본 탭바 사용 시 주석 해제
//    private var mainTabView: some View {
//        TabView {
//            TimerView(viewModel: timerViewModel)
//                .tabItem {
//                    Image(.icTimer)
//                        .renderingMode(.template)
//                    Text("빵굽기")
//                }
//            
//            ToDoView(viewModel: makeTodoViewModel())
//                .tabItem {
//                    Image(.icBook)
//                        .renderingMode(.template)
//                    Text("할 일")
//                }
//// TODO: 2차 스프린트 이후 수정
////            Text("이웃")
////                .tabItem {
////                    Image(.icChat)
////                        .renderingMode(.template)
////                    Text("이웃")
////                }
//            
//            MyPageView()
//                .tabItem {
//                    Image(.icPerson)
//                        .renderingMode(.template)
//                    Text("마이")
//                }
//        }
//        .tint(Color(.staticblack))
//        .toolbarBackground(
//            Color(.componentAlternative),
//            for: .tabBar
//        )
//    }
    
    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            TimerView(viewModel: timerViewModel)
                .tabItem { EmptyView() }
                .tag(0)
            
            ToDoView(viewModel: makeTodoViewModel())
                .tabItem { EmptyView() }
                .tag(1)
            
            MyPageView()
                .tabItem { EmptyView() }
                .tag(2)
        }
        .overlay(alignment: .bottom) {
            customTabBar
        }
    }

    private var customTabBar: some View {
        HStack {
            tabBarItem(icon: Image(.icTimer), title: "빵굽기", tag: 0)
            tabBarItem(icon: Image(.icBook), title: "할 일", tag: 1)
            tabBarItem(icon: Image(.icPerson), title: "마이", tag: 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 49)
        .background(Color(.componentAlternative))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color(.labelDisable))
                .frame(height: 0.5)
        }
        .opacity(timerViewModel.state == .running || timerViewModel.state == .paused ? 0 : 1)
    }

    private func tabBarItem(icon: Image, title: String, tag: Int) -> some View {
        Button {
            selectedTab = tag
        } label: {
            VStack(spacing: 4) {
                icon
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == tag ? Color(.staticblack) : Color(.labelAssistive))
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(selectedTab == tag ? Color(.staticblack) : Color(.labelAssistive))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var checkedOffView: some View {
        let repo = TodoRepositoryImpl()
        let fetchUseCase = DefaultFetchTodosUseCase(repository: repo)
        let toggleUseCase = TimerToggleTodoCompletionUseCase(todoRepository: repo)
        let addUseCase = DefaultAddTodoUseCase(repository: repo)
        let editUseCase = DefaultEditTodoUseCase(repository: repo)
        
        let checkedOffViewModel = TimerCheckedOffViewModel(
            fetchUseCase: fetchUseCase,
            toggleUseCase: toggleUseCase,
            addUseCase: addUseCase,
            editUseCase: editUseCase
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
        let repo = TodoRepositoryImpl()
        let fetchUseCase = DefaultFetchTodosUseCase(repository: repo)
        let toggleUseCase = TimerToggleTodoCompletionUseCase(todoRepository: repo)
        let addUseCase = DefaultAddTodoUseCase(repository: repo)
        let writeCommitmentMessageUseCase = DefaultWriteCommitmentMessageUseCase(repository:  WriteCommitmentMessageRepository())
        let reorderTodoUseCase = DefaultReorderTodoUseCase(repository: repo)
        return TodoViewModel(
            fetchUseCase: fetchUseCase,
            toggleUseCase: toggleUseCase,
            addUseCase: addUseCase,
            writeCommitmentMessageUseCase: writeCommitmentMessageUseCase,
            reorderTodoUseCase: reorderTodoUseCase
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
