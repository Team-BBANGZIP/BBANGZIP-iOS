//
//  TodoData.swift
//  BBANGZIP
//
//  Created by 최유빈 on 8/31/25.
//

import Foundation

struct TodoData: Codable {
    var myPromiseMessage: String
    let summary: TodoSummary
    var categories: [Category]
}
