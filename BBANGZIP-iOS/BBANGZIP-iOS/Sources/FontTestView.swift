//
//  FontTestView.swift
//  BBANGZIP
//
//  Created by 송여경 on 5/6/25.
//

import SwiftUI

struct FontTestView: View {
    let samples: [(String, bbangzipFont)] = [
        ("타이머 폰트", .timer),
        ("피커1", .picker1),
        ("타이틀1", .title1),
        ("타이틀2", .title2),
        ("타이틀3", .title3),
        ("서브타이틀1", .subtitle1),
        ("서브타이틀2", .subtitle2),
        ("서브타이틀3", .subtitle3),
        ("바디1", .body1),
        ("바디2", .body2),
        ("바디3", .body3),
        ("바디4", .body4),
        ("라벨1", .label1),
        ("라벨2", .label2),
        ("라벨3", .label3),
        ("라벨4", .label4),
        ("라벨5", .label5),
        ("라벨6", .label6),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(
                    samples,
                    id: \.1
                ) { (text, fontType) in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.red.opacity(0.5))
                            .frame(height: fontType.lineHeight)
                        
                        bbangText(
                            text,
                            fontType: fontType
                        )
//                            .padding(.vertical, 4)
                            .background(Color(.labelAlternative))
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("폰트 테스트")
    }
}
