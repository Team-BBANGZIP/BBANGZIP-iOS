//
//  ConfigManager.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import Foundation

enum ConfigManager {
    static let baseURL: String = Bundle.main.infoDictionary?["BASE_URL"] as! String
    static let kakaoAppKey: String = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as! String
}
