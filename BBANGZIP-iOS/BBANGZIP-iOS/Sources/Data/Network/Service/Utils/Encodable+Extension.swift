//
//  Encodable+Extension.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Sendable] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        
        return dictionary.compactMapValues { value in
            if let sendableValue = value as? Sendable {
                return sendableValue
            }
            return nil
        }
    }
}
