//
//  DeviceInfoProvider.swift
//  BBANGZIP
//
//  Created by 송여경 on 10/10/25.
//

import UIKit

@MainActor
struct DeviceInfoProvider {
    static func getDeviceName() -> String {
        return UIDevice.current.name
    }
    
    static func getDeviceType() -> SignInRequestDTO.DeviceType {
        let idiom = UIDevice.current.userInterfaceIdiom
        switch idiom {
        case .phone:
            return .phone
        case .pad:
            return .tablet
        default:
            return .phone
        }
    }
    
    static func getOSType() -> String {
        return UIDevice.current.systemName
    }
    
    static func getOSVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
}
