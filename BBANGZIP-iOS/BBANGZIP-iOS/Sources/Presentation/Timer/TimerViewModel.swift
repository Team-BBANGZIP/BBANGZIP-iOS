//
//  TimerViewModel.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

import SwiftUI
import Combine

enum TimerState {
    case initial
    case running
    case paused
    case done
}

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var breadCount: Int = 1
    @Published var announceMessage: String = "오늘의 빵을 구워보세요!"
    @Published var leftTimeText: String = "30:00" // TODO: 초기값 직접 넣기 개선
    @Published var progressPercentage: CGFloat = 0.01
    @Published var state: TimerState = .initial // TODO: 전체 State 기반으로 리팩토링 고려해보기
    @Published var isHour: Bool = false
    @Published var leftSeconds: Int
    
    @Published var isRefreshSheetOn: Bool = false
    @Published var isResetSheetOn: Bool = false
    @Published var isCompleteSheetOn: Bool = false
    
    private let timerUseCase: TimerUseCase
    private var timerTask: Task<Void, Never>?
    
    private var timeCase: TimerCase = .halfHour
    
    private var cancellables = Set<AnyCancellable>()
    
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        leftSeconds = timeCase.totalSeconds
        bind()
    }
    
    private func bind() {
        $isHour
            .sink { [weak self] isHour in
                guard let self else { return }
                timeCase = isHour ? .oneHour : .halfHour
                leftSeconds = timeCase.totalSeconds
                leftTimeText = formatTime(seconds: leftSeconds)
            }
            .store(in: &cancellables)
    }
    
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

    func pauseTimer() {
        state = .paused
        announceMessage = "잠시 쉬는 중..."
        timerUseCase.stop()
        timerTask?.cancel()
    }

    func resumeTimer() {
        state = .running
        timerTask = Task {
            for await remainingSeconds in timerUseCase.timerStream(from: leftSeconds) {
                leftSeconds = remainingSeconds
                leftTimeText = formatTime(seconds: remainingSeconds)
                let progress = 1 - CGFloat(remainingSeconds) / CGFloat(timeCase.totalSeconds)
                progressPercentage = progress <= 0.01 ? 0.01 : progress
            }
            if leftSeconds == 0 {
                state = .done
                announceMessage = "빵이 완성됐어요!"
                isCompleteSheetOn = true
            }
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
    
    func refreshTimer() {
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = timeCase.totalSeconds
        leftTimeText = formatTime(seconds: leftSeconds)
        progressPercentage = 0.01
        resumeTimer()
    }
    
    func presentResetSheet() {
        isResetSheetOn = true
    }

    func resetTimer() {
        state = .initial
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = timeCase.totalSeconds
        leftTimeText = formatTime(seconds: leftSeconds)
        progressPercentage = 0.01
        announceMessage = "오늘의 빵을 구워보세요!"
    }

    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
