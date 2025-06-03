//
//  CutomColor.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/6/25.
//

import SwiftUI

extension Color { // TODO: 밑에 Modifier와 함께 개선
    static let accentColor = BBANGZIPAsset.Assets.accentColor.swiftUIColor
    static let backgroundAlternative = BBANGZIPAsset.Assets.backgroundAlternative.swiftUIColor
    static let backgroundDimmer = BBANGZIPAsset.Assets.backgroundDimmer.swiftUIColor
    static let backgroundNomal = BBANGZIPAsset.Assets.backgroundNomal.swiftUIColor
    static let backgroundStrong = BBANGZIPAsset.Assets.backgroundStrong.swiftUIColor
    static let backgroundgray = BBANGZIPAsset.Assets.backgroundgray.swiftUIColor
    static let componentAlternative = BBANGZIPAsset.Assets.componentAlternative.swiftUIColor
    static let componentStrong = BBANGZIPAsset.Assets.componentStrong.swiftUIColor
    static let labelAlternative = BBANGZIPAsset.Assets.labelAlternative.swiftUIColor
    static let labelAssistive = BBANGZIPAsset.Assets.labelAssistive.swiftUIColor
    static let labelDisable = BBANGZIPAsset.Assets.labelDisable.swiftUIColor
    static let labelNeutral = BBANGZIPAsset.Assets.labelNeutral.swiftUIColor
    static let labelNomal = BBANGZIPAsset.Assets.labelNomal.swiftUIColor
    static let labelStrong = BBANGZIPAsset.Assets.labelStrong.swiftUIColor
    static let primaryLight = BBANGZIPAsset.Assets.primaryLight.swiftUIColor
    static let primaryNormal = BBANGZIPAsset.Assets.primaryNormal.swiftUIColor
    static let primaryStrong = BBANGZIPAsset.Assets.primaryStrong.swiftUIColor
    static let secondaryLight = BBANGZIPAsset.Assets.secondaryLight.swiftUIColor
    static let secondaryNormal = BBANGZIPAsset.Assets.secondaryNormal.swiftUIColor
    static let secondaryStrong = BBANGZIPAsset.Assets.secondaryStrong.swiftUIColor
    static let staticblack = BBANGZIPAsset.Assets.staticblack.swiftUIColor
    static let staticwhite = BBANGZIPAsset.Assets.staticwhite.swiftUIColor
    static let todoblue1 = BBANGZIPAsset.Assets.todoblue1.swiftUIColor
    static let todoblue2 = BBANGZIPAsset.Assets.todoblue2.swiftUIColor
    static let todogreen1 = BBANGZIPAsset.Assets.todogreen1.swiftUIColor
    static let todogreen2 = BBANGZIPAsset.Assets.todogreen2.swiftUIColor
    static let todopurple2 = BBANGZIPAsset.Assets.todopurple2.swiftUIColor
    static let todopurple1 = BBANGZIPAsset.Assets.todopurple1.swiftUIColor
    static let todored1 = BBANGZIPAsset.Assets.todored1.swiftUIColor
    static let todored2 = BBANGZIPAsset.Assets.todored2.swiftUIColor
    static let todoyellow1 = BBANGZIPAsset.Assets.todoyellow1.swiftUIColor
    static let todoyellow2 = BBANGZIPAsset.Assets.todoyellow2.swiftUIColor
}

enum BbangzipColor {
    case accentColor
    case backgroundAlternative
    case backgroundDimmer
    case backgroundNomal
    case backgroundStrong
    case backgroundgray
    case componentAlternative
    case componentStrong
    case labelAlternative
    case labelAssistive
    case labelDisable
    case labelNeutral
    case labelNomal
    case labelStrong
    case primaryLight
    case primaryNormal
    case primaryStrong
    case secondaryLight
    case secondaryNormal
    case secondaryStrong
    case staticblack
    case staticwhite
    case todoblue1
    case todoblue2
    case todogreen1
    case todogreen2
    case todopurple2
    case todopurple1
    case todored1
    case todored2
    case todoyellow1
    case todoyellow2
    
    var swiftUIColor: Color {
        switch self {
        case .accentColor:
            return BBANGZIPAsset.Assets.accentColor.swiftUIColor
        case .backgroundAlternative:
            return BBANGZIPAsset.Assets.backgroundAlternative.swiftUIColor
        case .backgroundDimmer:
            return BBANGZIPAsset.Assets.backgroundDimmer.swiftUIColor
        case .backgroundNomal:
            return BBANGZIPAsset.Assets.backgroundNomal.swiftUIColor
        case .backgroundStrong:
            return BBANGZIPAsset.Assets.backgroundStrong.swiftUIColor
        case .backgroundgray:
            return BBANGZIPAsset.Assets.backgroundgray.swiftUIColor
        case .componentAlternative:
            return BBANGZIPAsset.Assets.componentAlternative.swiftUIColor
        case .componentStrong:
            return BBANGZIPAsset.Assets.componentStrong.swiftUIColor
        case .labelAlternative:
            return BBANGZIPAsset.Assets.labelAlternative.swiftUIColor
        case .labelAssistive:
            return BBANGZIPAsset.Assets.labelAssistive.swiftUIColor
        case .labelDisable:
            return BBANGZIPAsset.Assets.labelDisable.swiftUIColor
        case .labelNeutral:
            return BBANGZIPAsset.Assets.labelNeutral.swiftUIColor
        case .labelNomal:
            return BBANGZIPAsset.Assets.labelNomal.swiftUIColor
        case .labelStrong:
            return BBANGZIPAsset.Assets.labelStrong.swiftUIColor
        case .primaryLight:
            return BBANGZIPAsset.Assets.primaryLight.swiftUIColor
        case .primaryNormal:
            return BBANGZIPAsset.Assets.primaryNormal.swiftUIColor
        case .primaryStrong:
            return BBANGZIPAsset.Assets.primaryStrong.swiftUIColor
        case .secondaryLight:
            return BBANGZIPAsset.Assets.secondaryLight.swiftUIColor
        case .secondaryNormal:
            return BBANGZIPAsset.Assets.secondaryNormal.swiftUIColor
        case .secondaryStrong:
            return BBANGZIPAsset.Assets.secondaryStrong.swiftUIColor
        case .staticblack:
            return BBANGZIPAsset.Assets.staticblack.swiftUIColor
        case .staticwhite:
            return BBANGZIPAsset.Assets.staticwhite.swiftUIColor
        case .todoblue1:
            return BBANGZIPAsset.Assets.todoblue1.swiftUIColor
        case .todoblue2:
            return BBANGZIPAsset.Assets.todoblue2.swiftUIColor
        case .todogreen1:
            return BBANGZIPAsset.Assets.todogreen1.swiftUIColor
        case .todogreen2:
            return BBANGZIPAsset.Assets.todogreen2.swiftUIColor
        case .todopurple2:
            return BBANGZIPAsset.Assets.todopurple2.swiftUIColor
        case .todopurple1:
            return BBANGZIPAsset.Assets.todopurple1.swiftUIColor
        case .todored1:
            return BBANGZIPAsset.Assets.todored1.swiftUIColor
        case .todored2:
            return BBANGZIPAsset.Assets.todored2.swiftUIColor
        case .todoyellow1:
            return BBANGZIPAsset.Assets.todoyellow1.swiftUIColor
        case .todoyellow2:
            return BBANGZIPAsset.Assets.todoyellow2.swiftUIColor
        }
    }
}

extension View {
    func bbangColor(_ color: BbangzipColor) -> some View {
        modifier(BbangColorModifier(color: color))
    }
}

struct BbangColorModifier: ViewModifier {
    private let color: BbangzipColor
    
    init(color: BbangzipColor) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color.swiftUIColor)
    }
}
