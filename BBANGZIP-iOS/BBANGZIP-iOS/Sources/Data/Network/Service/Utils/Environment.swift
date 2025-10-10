//
//  Environment.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

enum Environment {
    static let baseURL: String = Bundle.main.infoDictionary?["BASE_URL"] as! String
}
