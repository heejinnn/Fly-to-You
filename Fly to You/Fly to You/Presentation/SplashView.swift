//
//  SplashView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

struct SplashView: View {

    var body: some View {
        GifView(gifName: "earth_round")
                .frame(width: 200, height: 200)
    }
}

#Preview {
    SplashView()
}

