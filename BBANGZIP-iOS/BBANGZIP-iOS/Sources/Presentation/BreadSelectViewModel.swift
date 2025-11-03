//
//  BreadSelectViewMddel.swift
//  BBANGZIP
//
//  Created by 최유빈 on 11/3/25.
//

import SwiftUI

@MainActor
final class BreadSelectViewModel: ObservableObject {
    @Published var breadList: BreadList
    private let getBreadsUseCase: GetBreadsUseCase
    
    init(breadList: BreadList, getBreadsUseCase: GetBreadsUseCase) {
        self.breadList = breadList
        self.getBreadsUseCase = getBreadsUseCase
        
        getBreadList()
    }
    
    private func getBreadList() {
        Task {
            do {
                let breads = try await getBreadsUseCase.execute()
                await MainActor.run {
                    breadList = breads
                    print(breadList)
                }
            } catch {
                LoggerFactory.create(category: .data)
                    .error("Failed to get BreadList: \(error.localizedDescription)")
            }
        }
    }
}
