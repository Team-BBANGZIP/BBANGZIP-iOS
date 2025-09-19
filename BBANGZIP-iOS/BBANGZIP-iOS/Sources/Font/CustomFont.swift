//
//  CustomFont.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/6/25.
//

import SwiftUI

enum BbangzipFont: Sendable {
    case timer
    case picker1, picker2
    case title1, title2, title3, title4
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
        case .title4:
            return 14
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
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.extraBold, size: size)!.lineHeight - size) * 1.0
        case .picker1:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.4
        case .picker2:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        case .title1:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.2
        case .title2:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.2
        case .title3:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.4
        case .title4:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.4
        case .subtitle1:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        case .subtitle2:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.regular, size: size)!.lineHeight - size) * 1.4
        case .subtitle3:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.5
        case .body1:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        case .body2:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        case .body3:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        case .body4:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        case .label1:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.2
        case .label2:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.regular, size: size)!.lineHeight - size) * 1.2
        case .label3:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.2
        case .label4:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.regular, size: size)!.lineHeight - size) * 1.2
        case .label5:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.semiBold, size: size)!.lineHeight - size) * 1.4
        case .label6:
            return (UIFont(font: BBANGZIPFontFamily.Pretendard.medium, size: size)!.lineHeight - size) * 1.4
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        case .timer:
            return size * -0.05
        case .picker1, .picker2, .title1, .title2, .title3, .title4,
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
        case .title1, .title3, .title4, .picker1, .picker2, .label1, .label3, .label5:
            return BBANGZIPFontFamily.Pretendard.semiBold.swiftUIFont(size: size)
        case .subtitle2, .label2, .label4:
            return BBANGZIPFontFamily.Pretendard.regular.swiftUIFont(size: size)
        }
    }
}

struct BbangFontModifier: ViewModifier {
    private let font: BbangzipFont
    
    init(font: BbangzipFont) {
        self.font = font
    }
    
    func body(content: Content) -> some View {
        content
            .font(font.swiftUIFont)
            .lineSpacing(font.lineHeight - font.size)
            .kerning(font.letterSpacing)
    }
}

extension View {
    func bbangFont(_ font: BbangzipFont) -> some View {
        modifier(BbangFontModifier(font: font))
    }
}

struct BbangText: View {
    private let title: String
    private let font: BbangzipFont
    private let color: Color?
    
    init(
        _ title: String,
        font: BbangzipFont,
        color: Color? = Color(.label)
    ) {
        self.title = title
        self.font = font
        self.color = color
    }
    
    var body: some View {
        Text(title)
            .bbangFont(font)
            .foregroundStyle(color ?? Color(.black))
    }
}
