//
//  TaskStorage.swift
//  BBANGZIP
//
//  Created by 송여경 on 8/31/25.
//

import Foundation

final class TaskStorage: @unchecked Sendable {
    private var task: Task<Void, Never>?
    private var continuation: AsyncStream<Int>.Continuation?
    private let lock = NSLock()
    
    func setTask(_ newTask: Task<Void, Never>) {
        lock.withLock {
            task?.cancel()
            task = newTask
        }
    }
    
    func setContinuation(_ newContinuation: AsyncStream<Int>.Continuation) {
        lock.withLock {
            continuation = newContinuation
        }
    }
    
    func cancelTask() {
        lock.withLock {
            task?.cancel()
            task = nil
        }
    }
    
    func finishContinuation() {
        lock.withLock {
            continuation?.finish()
            continuation = nil
        }
    }
}

extension NSLock {
    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try body()
    }
}
