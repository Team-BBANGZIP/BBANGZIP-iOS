//
//  TimerUseCase.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

protocol TimerUseCase: Sendable {
    func timerStream(from seconds: Int) -> AsyncStream<Int>
    func stop()
}

final class TimerUseCaseImpl: TimerUseCase {
    private let taskStorage = TaskStorage()
    
    func timerStream(from seconds: Int) -> AsyncStream<Int> {
        AsyncStream { continuation in
            taskStorage.setContinuation(continuation)
            var remaining = seconds
            
            let task = Task {
                while remaining > 0 && !Task.isCancelled {
                    do {
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        remaining -= 1
                        continuation.yield(remaining)
                    } catch {
                        LoggerFactory.create(category: .data)
                            .debug("Task sleep Cancelled, error: \(error.localizedDescription)")
                    }
                }
                
                continuation.finish()
            }
            
            taskStorage.setTask(task)
        }
    }
    
    func stop() {
        taskStorage.cancelTask()
        taskStorage.finishContinuation()
    }
}
