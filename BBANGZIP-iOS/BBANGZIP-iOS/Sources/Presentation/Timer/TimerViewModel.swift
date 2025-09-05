//
//  TimerViewModel.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

import SwiftUI
import Combine

@MainActor
final class TimerViewModel: ObservableObject {
    public enum TimerState {
        case initial
        case running
        case paused
        case done
    }
    
    @Published var breadCount: Int = 0
    @Published var announceText: String = "오늘의 빵을 구워보세요!"
    @Published var leftTimeText: String = ""
    @Published var progressPercentage: CGFloat = 0.01
    @Published var state: TimerState = .initial
    @Published var isHour: Bool = false
    @Published var resetSheetLeftTimeText: String = ""
    @Published var currentBreadLevel: Int = 1
    
    @Published var isRefreshSheetOn: Bool = false
    @Published var isResetSheetOn: Bool = false
    @Published var isCompleteSheetOn: Bool = false
    @Published var isBreadSelectSheetOn: Bool = false
    @Published var shouldShowCheckedOffView: Bool = false
    
    private let timerUseCase: TimerUseCase
    private let breadCountUseCase: BreadCountUseCase
    private var timerTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var leftSeconds: Int = isHour ? 3600: 1800
    
    init(
        timerUseCase: TimerUseCase,
        breadCountUseCase: BreadCountUseCase
    ) {
        self.timerUseCase = timerUseCase
        self.breadCountUseCase = breadCountUseCase
        bind()
        loadBreadCount()
    }
    
    func resetToInitial() {
        resetTimer()
    }
    
    func startAdditionalTimer() {
        isHour = false
        resumeTimer()
    }
    
    func resetCheckedOffViewFlag() {
        shouldShowCheckedOffView = false
    }
    
    func pauseForLock() {
        if state == .running {
            timerControlButtonTapped()
        }
    }
    
    // MARK: - Private Methods
    private func bind() {
        $isHour
            .sink { [weak self] isHour in
                guard let self else { return }
                leftSeconds = isHour ? 3600 : 1800
                leftTimeText = formatTime(seconds: leftSeconds)
                resetSheetLeftTimeText = leftSeconds >= 60 ? "\(leftSeconds / 60)분" : "\(leftSeconds % 60)초"
                currentBreadLevel = 1
            }
            .store(in: &cancellables)
    }
    
    private func loadBreadCount() {
        Task {
            do {
                let count = try await breadCountUseCase.getTodayBreadCount()
                await MainActor.run {
                    breadCount = count
                }
            } catch {
                LoggerFactory.create(category: .data)
                    .error("Failed to load bread count: \(error.localizedDescription)")
            }
        }
    }
    
    private func pauseTimer() {
        state = .paused
        announceText = "잠시 쉬는 중..."
        timerUseCase.stop()
        timerTask?.cancel()
    }
    
    private func resumeTimer() {
        state = .running
        currentBreadLevel = calculateBreadLevel(remainingSeconds: leftSeconds)
        timerTask = Task {
            for await remainingSeconds in timerUseCase.timerStream(from: leftSeconds) {
                leftSeconds = remainingSeconds
                leftTimeText = formatTime(seconds: remainingSeconds)
                let progress = 1 - CGFloat(remainingSeconds) / CGFloat(isHour ? 3600 : 1800)
                progressPercentage = progress <= 0.01 ? 0.01 : progress
                resetSheetLeftTimeText = leftSeconds >= 60 ? "\(leftSeconds / 60)분" : "\(leftSeconds % 60)초"
                currentBreadLevel = calculateBreadLevel(remainingSeconds: remainingSeconds)
            }
            if leftSeconds == 0 {
                state = .done
                announceText = "빵이 완성됐어요!"
                currentBreadLevel = 5
                loadBreadCount()
                isCompleteSheetOn = true
            }
        }
    }
    
    private func refreshTimer() {
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = isHour ? 3600 : 1800
        leftTimeText = formatTime(seconds: leftSeconds)
        progressPercentage = 0.01
        currentBreadLevel = 1
        resumeTimer()
    }
    
    private func resetTimer() {
        state = .initial
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = isHour ? 3600 : 1800
        leftTimeText = formatTime(seconds: leftSeconds)
        progressPercentage = 0.01
        currentBreadLevel = 1
        announceText = "오늘의 빵을 구워보세요!"
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func calculateBreadLevel(remainingSeconds: Int) -> Int {
        if isHour {
            let elapsedSeconds = 3600 - remainingSeconds
            switch elapsedSeconds {
            case 0..<1:
                return 2
            case 1..<900:
                return 2
            case 900..<1800:
                return 3
            case 1800..<2700:
                return 4
            case 2700..<3600:
                return 5
            default:
                return 5
            }
        } else {
            let elapsedSeconds = 1800 - remainingSeconds
            switch elapsedSeconds {
            case 0..<1:
                return 2
            case 1..<450:
                return 2
            case 450..<900:
                return 3
            case 900..<1350:
                return 4
            case 1350..<1800:
                return 5
            default:
                return 5
            }
        }
    }
    
    private func canGetBreadReward() -> (count: Int, imageName: String) {
        let totalSeconds = isHour ? 3600 : 1800
        let elapsedSeconds = totalSeconds - leftSeconds
        let halfTime = totalSeconds / 2
        
        if isHour {
            if elapsedSeconds >= halfTime {
                return (2, "prize2")
            } else {
                return (1, "prize")
            }
        } else {
            if elapsedSeconds >= halfTime {
                return (1, "prize")
            } else {
                return (1, "prize")
            }
        }
    }
    
    var resetSheetBreadCount: String {
        let reward = canGetBreadReward()
        return reward.count == 1 ? "한" : "두"
    }
    
    var resetSheetImageName: String {
        return canGetBreadReward().imageName
    }
    
    var completeSheetBreadCount: String {
        return isHour ? "두" : "한"
    }
    
    var completeSheetImageName: String {
        return isHour ? "prize2" : "prize"
    }
}

// MARK: - User Interaction
extension TimerViewModel {
    func timerControlButtonTapped() {
        if state == .running {
            pauseTimer()
        } else if state == .done {
            resetTimer()
            resumeTimer()
        } else {
            resumeTimer()
        }
    }
    
    func refreshButtonTapped() {
        if state == .done {
            resetTimer()
        } else {
            state = .paused
            pauseTimer()
            isRefreshSheetOn = true
        }
    }
    
    func resetButtonTapped() {
        if state == .done {
            resetTimer()
        } else {
            state = .paused
            pauseTimer()
            isResetSheetOn = true
        }
    }
    
    func refreshSheetBackButtonTapped() {
        isRefreshSheetOn = false
    }
    
    func refreshSheetRefreshButtonTapped() {
        refreshTimer()
        isRefreshSheetOn = false
    }
    
    func resetSheetBackButtonTapped() {
        isResetSheetOn = false
    }
    
    func resetSheetResetButtonTapped() {
        resetTimer()
        isResetSheetOn = false
    }
    
    func completeSheetMoreButtonTapped() {
        // 30분/60분 더 하기
        timerControlButtonTapped()
        isCompleteSheetOn = false
    }
    
    func completeSheetCompleteButtonTapped() {
        // 완료한 일 체크 버튼 - CheckedOffView로 이동
        shouldShowCheckedOffView = true
        isCompleteSheetOn = false
    }
    
    func breadImageTapped() {
        if state == .initial {
            isBreadSelectSheetOn = true
        }
    }
}
