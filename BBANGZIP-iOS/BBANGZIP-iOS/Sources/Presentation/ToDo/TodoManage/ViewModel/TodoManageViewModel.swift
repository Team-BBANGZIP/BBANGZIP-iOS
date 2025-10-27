//
//  TodoManageViewModel.swift
//  BBANGZIP
//
//  Created by 김송희 on 9/28/25.
//

import SwiftUI

@MainActor
final class TodoManageViewModel: ObservableObject {
    private let titleBinding: Binding<String>
    private let startTimeBinding: Binding<String?>
    private let isAlertedBinding: Binding<Bool>
    
    @Published var title: String
    @Published var category: String
    @Published var startTimeString: String?
    @Published var isAlerted: Bool
    @Published var isCompleted: Bool
    @Published var changeDate: Date = Date()
    @Published var repeatDate: Date = Date()
    
    @Published var isEditSheetPresented: Bool = false
    @Published var isStartTimeSheetPresented: Bool = false
    @Published var isChangeDateSheetPresented: Bool = false
    @Published var isRepeatSheetPresented: Bool = false

    private let onDelete: () -> Void
    private let onPostpone: () -> Void
    private let onDuplicate: () -> Void
    private let onChangeDate: () -> Void
    
    init(
        title: Binding<String>,
        category: String,
        startTime: Binding<String?>,
        isAlerted: Binding<Bool>,
        isCompleted: Bool,
        onDelete: @escaping () -> Void,
        onPostpone: @escaping () -> Void,
        onDuplicate: @escaping () -> Void,
        onChangeDate: @escaping () -> Void
    ) {
        self.titleBinding = title
        self.startTimeBinding = startTime
        self.isAlertedBinding = isAlerted
        self.title = title.wrappedValue
        self.category = category
        self.startTimeString = startTime.wrappedValue
        self.isAlerted = isAlerted.wrappedValue
        self.isCompleted = isCompleted
        self.onDelete = onDelete
        self.onPostpone = onPostpone
        self.onDuplicate = onDuplicate
        self.onChangeDate = onChangeDate
    }
    
    var startTimeDate: Date? {
        get { startTimeString.flatMap { DateFormatter.inputTimeFormatter.date(from: $0) } }
        set {
            startTimeString = newValue.map { DateFormatter.inputTimeFormatter.string(from: $0) }
            startTimeBinding.wrappedValue = startTimeString
        }
    }
    
    var formattedStartTime: String {
        startTimeDate.map { DateFormatter.displayTimeFormatter.string(from: $0) } ?? "미설정"
    }
    
    func tapEdit() { isEditSheetPresented = true }
    func tapStartTime() { isStartTimeSheetPresented = true }
    
    func setTitle(_ newTitle: String) {
        title = newTitle
        titleBinding.wrappedValue = newTitle
    }
    
    func setAlerted(_ newValue: Bool) {
        isAlerted = newValue
        isAlertedBinding.wrappedValue = newValue
    }
    
    // TODO: 삭제, 미루기, 복제하기, 날짜 바꾸기 기능 구현
}
