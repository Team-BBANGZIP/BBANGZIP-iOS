//
//  TimerUseCase.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/20/25.
//

protocol TimerUseCase {
    func timerStream(from seconds: Int) -> AsyncStream<Int>
    func stop()
}

final class TimerUseCaseImpl: TimerUseCase {
    private var task: Task<Void, Never>?
    private var continuation: AsyncStream<Int>.Continuation?

    func timerStream(from seconds: Int) -> AsyncStream<Int> {
        AsyncStream { continuation in
            self.continuation = continuation
            var remaining = seconds

            task = Task {
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
        }
    }

    func stop() {
        task?.cancel()
        continuation?.finish()
        continuation = nil
    }
}
