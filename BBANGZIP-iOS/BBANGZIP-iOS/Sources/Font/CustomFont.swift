//
//  CustomFont.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/6/25.
//

import SwiftUI

enum bbangzipFont: Sendable {
    case timer
    case picker1, picker2
    case title1, title2, title3
    case subtitle1, subtitle2, subtitle3
    case body1, body2, body3, body4
    case label1, label2, label3, label4, label5, label6
    
    var size: CGFloat {
        switch self {
        case .timer:
            return 80
        case .picker1, .picker2, .title1:
            return 20
        case .title2:
            return 18
        case .title3, .body1:
            return 16
        case .subtitle1, .subtitle2, .body2, .label1, .label2:
            return 14
        case .subtitle3, .body4, .label3, .label4:
            return 12
        case .body3:
            return 13
        case .label5, .label6:
            return 10
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .timer:
            return size * 1.0
        case .title1, .title2:
            return size * 1.2
        case .title3, .picker1, .picker2, .subtitle1, .subtitle2,
                .body1, .body2, .body3, .body4, .label5, .label6:
            return size * 1.4
        case .subtitle3:
            return size * 1.5
        case .label1, .label2, .label3, .label4:
            return size * 1.2
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        case .timer:
            return size * -0.05
        case .picker1, .picker2, .title1, .title2, .title3,
                .subtitle1, .subtitle2, .subtitle3, .body1, .body2,
                .body4, .label1, .label2, .label3, .label4:
            return size * -0.03
        case .body3, .label5, .label6:
            return size * 0.02
        }
    }
    
    var swiftUIFont: Font {
        switch self {
        case .timer:
            return BBANGZIPFontFamily.Pretendard.extraBold.swiftUIFont(size: size)
        case .title2, .subtitle1, .subtitle3, .body1, .body2,
                .body3, .body4, .label6:
            return BBANGZIPFontFamily.Pretendard.medium.swiftUIFont(size: size)
        case .title1, .title3, .picker1, .picker2, .label1, .label3, .label5:
            return BBANGZIPFontFamily.Pretendard.semiBold.swiftUIFont(size: size)
        case .subtitle2, .label2, .label4:
            return BBANGZIPFontFamily.Pretendard.regular.swiftUIFont(size: size)
        }
    }
}

struct bbangModifier: ViewModifier {
    private let font: bbangzipFont
    
    init(font: bbangzipFont) {
        self.font = font
    }
    
    func body(content: Content) -> some View {
        content
            .font(font.swiftUIFont)
            .lineSpacing((font.lineHeight - font.size) / 4)
            .kerning(font.letterSpacing)
    }
}

extension View {
    func bbangFont(_ font: bbangzipFont) -> some View {
        modifier(bbangModifier(font: font))
    }
}

struct bbangText: View {
    private let title: String
    private let fontType: bbangzipFont
    private let color: Color?
    
    init(
        _ title: String,
        fontType: bbangzipFont,
        color: Color? = Color(.label)
    ) {
        self.title = title
        self.fontType = fontType
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .bbangFont(fontType)
            .foregroundStyle(color ?? Color(.label))
    }
}
