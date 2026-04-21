//
//  LottieView.swift
//  BBANGZIP
//
//  Created by 송여경 on 4/21/26.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let fileName: String
    var loopMode: LottieLoopMode = .playOnce

    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: fileName)
        animationView.loopMode = loopMode
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        return animationView
    }

    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}
