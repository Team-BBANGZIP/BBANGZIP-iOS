//
//  SubscriptArray.swift
//  BBANGZIP
//
//  Created by 최유빈 on 9/24/25.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
