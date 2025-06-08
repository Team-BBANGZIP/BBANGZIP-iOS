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
    enum TimerState {
        case initial
        case running
        case paused
        case done
    }

    @Published var breadCount: Int = 0
    @Published var announceText: String = "오늘의 빵을 구워보세요!"
    @Published var leftTimeText: String = "" // TODO: 초기값 어케함?
    @Published var progressPercentage: CGFloat = 0.01
    @Published var state: TimerState = .initial
    @Published var isHour: Bool = false
    @Published var resetSheetLeftTimeText: String = "" // TODO: 초기값 어케함?
    
    @Published var isRefreshSheetOn: Bool = false
    @Published var isResetSheetOn: Bool = false
    @Published var isCompleteSheetOn: Bool = false
    
    private let timerUseCase: TimerUseCase
    private var timerTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var leftSeconds: Int = isHour ? 3600: 1800
    
    init(timerUseCase: TimerUseCase) {
        self.timerUseCase = timerUseCase
        bind()
    }
    
    private func bind() {
        $isHour
            .sink { [weak self] isHour in
                guard let self else { return }
                leftSeconds = isHour ? 3600 : 1800
                leftTimeText = formatTime(seconds: leftSeconds)
                resetSheetLeftTimeText = leftSeconds >= 60 ? "\(leftSeconds / 60)분" : "\(leftSeconds % 60)초"
            }
            .store(in: &cancellables)
    }

    private func pauseTimer() {
        state = .paused
        announceText = "잠시 쉬는 중..."
        timerUseCase.stop()
        timerTask?.cancel()
    }

    private func resumeTimer() {
        state = .running
        timerTask = Task {
            for await remainingSeconds in timerUseCase.timerStream(from: leftSeconds) {
                leftSeconds = remainingSeconds
                leftTimeText = formatTime(seconds: remainingSeconds)
                let progress = 1 - CGFloat(remainingSeconds) / CGFloat(isHour ? 3600 : 1800)
                progressPercentage = progress <= 0.01 ? 0.01 : progress
                resetSheetLeftTimeText = leftSeconds >= 60 ? "\(leftSeconds / 60)분" : "\(leftSeconds % 60)초"
            }
            if leftSeconds == 0 {
                state = .done
                announceText = "빵이 완성됐어요!"
                isCompleteSheetOn = true // TODO: 바로 시트 띄우지 말고 서버 요청을 보내고 요청 성공 시에 시트 띄워야 함
            }
        }
    }
    
    private func refreshTimer() {
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = isHour ? 3600 : 1800
        leftTimeText = formatTime(seconds: leftSeconds)
        progressPercentage = 0.01
        resumeTimer()
    }

    private func resetTimer() {
        state = .initial
        timerUseCase.stop()
        timerTask?.cancel()
        leftSeconds = isHour ? 3600 : 1800
        leftTimeText = formatTime(seconds: leftSeconds)
        progressPercentage = 0.01
        announceText = "오늘의 빵을 구워보세요!"
    }

    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
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
        timerControlButtonTapped()
        isCompleteSheetOn = false
    }
    
    func completeSheetCompleteButtonTapped() {
        // TODO: 페이지 이동 변수 컨트롤
    }
}
