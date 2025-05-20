//
//  InfoItem.swift
//  BBANGZIP
//
//  Created by 조성민 on 5/17/25.
//

import Foundation

enum InfoItem {
    case baseURL
    case kakaoKey
    
    var value: String {
        switch self {
        case .baseURL:
            return Bundle.main.infoDictionary?["BASE_URL"] as! String
        case .kakaoKey:
            return Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as! String
        }
    }
}
