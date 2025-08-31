import SwiftUI

public struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel(
        timerUseCase: TimerUseCaseImpl(),
        breadCountUseCase: BreadCountUseCaseImpl(repository: BreadCountRepositoryImpl())
    )
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var wasPausedByLock = false
    
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
        ZStack {
            if timerViewModel.state == .running || timerViewModel.state == .paused {
                TimerView(viewModel: timerViewModel)
                    .transition(.opacity)
            } else {
                TabView {
                    TimerView(viewModel: timerViewModel)
                        .tabItem {
                            Image(.icTimer)
                                .renderingMode(.template)
                            Text("빵굽기")
                        }
                    
                    Text("할 일")
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
                    
                    Text("마이")
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
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: timerViewModel.state)
        .onChange(of: scenePhase) { newPhase in
            handleScenePhaseChange(newPhase)
        }
        .onChange(of: timerViewModel.state) { newState in
            handleTimerStateChange(newState)
        }
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
    
    private func handleTimerStateChange(_ state:  TimerViewModel.TimerState) {
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

extension TimerViewModel {
    func pauseForLock() {
        if state == .running {
            timerControlButtonTapped()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
