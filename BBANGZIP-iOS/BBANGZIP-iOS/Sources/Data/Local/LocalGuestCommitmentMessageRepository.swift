import Foundation

final class LocalGuestCommitmentMessageRepository: WriteCommitmentMessageRepositoryProtocol, @unchecked Sendable {
    private let store: LocalGuestTodoStore

    init(store: LocalGuestTodoStore = .shared) {
        self.store = store
    }

    func writeCommitmentMessage(request: CommitmentMessageWriteRequestDTO) async throws -> CommitmentMessage {
        store.updatePromiseMessage(request.commitmentMessage)
        return CommitmentMessage(commitmentMessage: request.commitmentMessage)
    }
}
