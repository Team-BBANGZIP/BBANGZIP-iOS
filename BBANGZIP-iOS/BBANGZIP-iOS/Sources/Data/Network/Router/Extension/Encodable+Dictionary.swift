//
//  Encodable+Dictionary.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Sendable] {
        guard
            let data = try? JSONEncoder().encode(self),
            let dictionary = try? JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as? [String: Sendable] else {
            LoggerFactory.create(category: .data)
                .debug("Encodable 객체 Dictionary 생성 실패")
            return [:]
        }
        return dictionary
    }
}
