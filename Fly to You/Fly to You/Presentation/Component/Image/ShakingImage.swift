//
//  ShakingImage.swift
//  Fly to You
//
//  Created by 최희진 on 8/19/25.
//

import SwiftUI

struct ShakingImage: View {
    @State private var isShaking = false

    var body: some View {
        Image(.paperplane)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(isShaking ? 5 : -5)) // 좌우로 흔들기
            .animation(
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: isShaking
            )
            .onAppear {
                isShaking = true
            }
    }
}
