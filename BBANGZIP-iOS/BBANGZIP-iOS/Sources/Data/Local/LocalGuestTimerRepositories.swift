import Foundation

final class LocalGuestBreadCountRepository: BreadCountRepository, @unchecked Sendable {
    private let store: LocalGuestTodoStore

    init(store: LocalGuestTodoStore = .shared) {
        self.store = store
    }

    func getTodayBreadCount() async throws -> BreadCount {
        BreadCount(todayBakedCount: store.todayBreadCount())
    }
}

final class LocalGuestTimerCompleteRepository: TimerCompleteRepositoryProtocol, @unchecked Sendable {
    private let store: LocalGuestTodoStore

    init(store: LocalGuestTodoStore = .shared) {
        self.store = store
    }

    func completeTimer(request: TimerCompleteRequestDTO) async throws -> TimerCompleteCount {
        let targetDate = DateFormatter.inputDateYMDFormatter.date(from: request.targetDate) ?? Calendar.current.appToday()
        store.addTimerBreadCount(request.count, targetDate: targetDate)
        return TimerCompleteCount(count: store.todayBreadCount())
    }
}
