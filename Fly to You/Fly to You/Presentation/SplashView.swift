//
//  SplashView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

struct SplashView: View {

    var body: some View {
        VStack{
            GifView(gifName: "earth_round")
                .foregroundColor(.clear)
                .frame(width: 600, height: 601)
                .clipped()
                .opacity(0.8)
                
        }
    }
}

#Preview {
    SplashView()
}

