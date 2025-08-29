//
//  DateFormatter+.swift
//  BBANGZIP
//
//  Created by 김송희 on 8/28/25.
//

import Foundation

extension DateFormatter {
    static let taskTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "a hh:mm"
        return formatter
    } ()
    
    static let repositoryTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
