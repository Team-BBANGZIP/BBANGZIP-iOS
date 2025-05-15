//
//  DateFormatter+Extension.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/14/25.
//

import Foundation

extension String {
    /// "HH:mm" 형식의 24시간 문자열을 "AM/PM h:mm" 형식으로 변환
    func toAmPmFormattedTime() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "a h:mm"
        outputFormatter.amSymbol = "AM"
        outputFormatter.pmSymbol = "PM"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        return outputFormatter.string(from: date)
    }
}
