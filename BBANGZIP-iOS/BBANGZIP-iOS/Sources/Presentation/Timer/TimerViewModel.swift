//
//  TimerViewModel.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

import SwiftUI
import Combine

enum TimerState {
    case running
    case paused
    case initial
}

@MainActor
final class TimerViewModel: ObservableObject {
    @Published var breadCount: Int = 0
    @Published var announceMessage: String = "오늘의 빵을 구워보세요!"
    @Published var leftTimeText: String = "30:00"
    @Published var leftTimePercentage: CGFloat = 1.0
    @Published var state: TimerState = .initial
    @Published var isTimerHour: Bool = false
    
    private let timerUseCase: TimerUseCase
    private var timerTask: Task<Void, Never>?
    
    private var leftSeconds: Int = 1800
    private var timeCase: TimerCase = .halfHour
    
    private var cancellables = Set<AnyCancellable>()
    
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        bind()
    }
    
    private func bind() {
        $isTimerHour
            .sink { [weak self] isHour in
                guard let self else { return }
                leftSeconds = isHour ? 3600 : 1800
                leftTimeText = formatTime(seconds: leftSeconds)
                timeCase = isHour ? .oneHour : .halfHour
            }
            .store(in: &cancellables)
    }
    
    func timerControlButtonTapped() {
        if state == .running {
            pauseTimer()
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
        announceMessage = ""
        timerTask = Task {
            for await remainingSeconds in timerUseCase.timerStream(from: leftSeconds) {
                print("leftSeconds : \(leftSeconds)")
                leftSeconds = remainingSeconds
                leftTimeText = formatTime(seconds: remainingSeconds)
                leftTimePercentage = CGFloat(remainingSeconds) / CGFloat(timeCase.totalSeconds)
            }
        }
    }
    
    func refreshTimer() {
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = timeCase.totalSeconds
        leftTimeText = formatTime(seconds: leftSeconds)
        leftTimePercentage = 1.0
        resumeTimer()
    }

    func resetTimer() {
        state = .initial
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = timeCase.totalSeconds
        leftTimeText = formatTime(seconds: leftSeconds)
        leftTimePercentage = 1.0
        announceMessage = "오늘의 빵을 구워보세요!"
    }

    func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
