import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

public struct ContentView: View {
    private enum AuthMode {
        case unauthenticated
        case guest
        case authenticated
    }
    
    @State private var isTodoNavigating: Bool = false
    
    @StateObject private var authenticatedTimerViewModel = TimerViewModel(
        timerUseCase: TimerUseCaseImpl(),
        breadCountUseCase: BreadCountUseCaseImpl(repository: BreadCountRepositoryImpl()),
        timerCompleteUseCase: DefaultTimerCompleteUseCase(repository: TimerCompleteRepository())
    )
    @StateObject private var guestTimerViewModel = TimerViewModel(
        timerUseCase: TimerUseCaseImpl(),
        breadCountUseCase: BreadCountUseCaseImpl(repository: LocalGuestBreadCountRepository()),
        timerCompleteUseCase: DefaultTimerCompleteUseCase(repository: LocalGuestTimerCompleteRepository())
    )
    
    @Environment(\.scenePhase) private var scenePhase
    @State private var wasPausedByLock = false
    @State private var showCheckedOffView = false
    @State private var isLaunch: Bool = true
    @State private var authMode: AuthMode = .unauthenticated
    @State private var showOnboarding: Bool = false
    
    @State private var selectedTab: Int = 0
    @State private var isMyPageInSubView: Bool = false
    
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
                            self.authMode = .authenticated
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("OnboardingDismissed"))) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.showOnboarding = false
                            self.authMode = .unauthenticated
                        }
                    }
            } else if authMode == .unauthenticated {
                LoginView()
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LoginSuccess"))) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.authMode = .authenticated
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ContinueAsGuest"))) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.authMode = .guest
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowOnboarding"))) { _ in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.showOnboarding = true
                        }
                    }
                    .onOpenURL { url in
                        if AuthApi.isKakaoTalkLoginUrl(url) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
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
            self.authMode = .authenticated
        } else {
            self.authMode = .unauthenticated
        }
    }
    
    private func handleAuthenticationFailure() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentTimerViewModel.state == .running {
                currentTimerViewModel.pauseForLock()
            }
            currentTimerViewModel.resetToInitial()
            
            showCheckedOffView = false
            wasPausedByLock = false
            UIApplication.shared.isIdleTimerDisabled = false
            
            authMode = .unauthenticated
        }
    }
    
    private var currentTimerViewModel: TimerViewModel {
        authMode == .guest ? guestTimerViewModel : authenticatedTimerViewModel
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
        .onChange(of: currentTimerViewModel.state) { oldState, newState in
            handleTimerStateChange(newState)
        }
        .onReceive(currentTimerViewModel.$shouldShowCheckedOffView) { shouldShow in
            if shouldShow {
                showCheckedOffView = true
                currentTimerViewModel.resetCheckedOffViewFlag()
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
            TimerView(viewModel: currentTimerViewModel)
                .tabItem { EmptyView() }
                .tag(0)
            
            ToDoView(viewModel: makeTodoViewModel(), onNavigationDepthChanged: { isDeep in
                isTodoNavigating = isDeep
            })
                .tabItem { EmptyView() }
                .tag(1)
            
            MyPageView(
                isInSubView: $isMyPageInSubView,
                isGuest: authMode == .guest,
                onLoginTapped: {
                    authMode = .unauthenticated
                }
            )
                .tabItem { EmptyView() }
                .tag(2)
        }
        .overlay(alignment: .bottom) {
            if !(selectedTab == 0 && currentTimerViewModel.state != .initial) && !(selectedTab == 2 && isMyPageInSubView) {
                customTabBar
                    .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentTimerViewModel.state)
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
        .opacity((currentTimerViewModel.state == .running || currentTimerViewModel.state == .paused) || isTodoNavigating ? 0 : 1)
    }
    
    private func tabBarItem(icon: Image, title: String, tag: Int) -> some View {
        Button {
            selectedTab = tag
        } label: {
            VStack(spacing: 4) {
                icon
                    .renderingMode(.template)
                    .foregroundColor(selectedTab == tag ? Color(.labelStrong) : Color(.labelAssistive))
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(selectedTab == tag ? Color(.labelStrong) : Color(.labelAssistive))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var checkedOffView: some View {
        let repo: TodoRepository = authMode == .guest ? LocalGuestTodoRepository() : TodoRepositoryImpl()
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
                currentTimerViewModel.resetToInitial()
            },
            onStartAdditionalTimer: {
                showCheckedOffView = false
                currentTimerViewModel.startAdditionalTimer()
            }
        )
    }
    
    private func makeTodoViewModel() -> TodoViewModel {
        let repo: TodoRepository = authMode == .guest ? LocalGuestTodoRepository() : TodoRepositoryImpl()
        let fetchUseCase = DefaultFetchTodosUseCase(repository: repo)
        let toggleUseCase = TimerToggleTodoCompletionUseCase(todoRepository: repo)
        let addUseCase = DefaultAddTodoUseCase(repository: repo)
        let commitmentRepository: WriteCommitmentMessageRepositoryProtocol = authMode == .guest
            ? LocalGuestCommitmentMessageRepository()
            : WriteCommitmentMessageRepository()
        let writeCommitmentMessageUseCase = DefaultWriteCommitmentMessageUseCase(repository: commitmentRepository)
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
            if currentTimerViewModel.state == .running {
                currentTimerViewModel.pauseForLock()
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
