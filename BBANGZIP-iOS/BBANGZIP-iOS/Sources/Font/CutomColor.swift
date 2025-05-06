//
//  CutomColor.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/6/25.
//

import SwiftUI

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
    case todoperple2
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
        case .todoperple2:
            return BBANGZIPAsset.Assets.todoperple2.swiftUIColor
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
