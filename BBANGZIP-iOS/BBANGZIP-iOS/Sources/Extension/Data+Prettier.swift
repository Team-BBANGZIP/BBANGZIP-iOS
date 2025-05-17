//
//  Data+Prettier.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Foundation

extension Data {
    var toPrettyPrintedString: String? {
        guard
            let object = try? JSONSerialization.jsonObject(
                with: self,
                options: []
            ),
            let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
            ),
            let prettyPrintedString = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
            )
        else {
            LoggerFactory.create(category: .etc)
                .debug("Data toPrettyPrintedString failed")
            return nil
        }
        
        return prettyPrintedString as String
    }
}
