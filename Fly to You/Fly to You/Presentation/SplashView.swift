//
//  SplashView.swift
//  Fly to You
//
//  Created by 최희진 on 4/13/25.
//

import SwiftUI

struct SplashView: View {
    
    @Binding var gifReady: Bool


    var body: some View {
        ZStack {
            GifView(gifName: "earth_round") {
                gifReady = true
            }
            .frame(width: 600, height: 600)
            .clipped()
            .opacity(0.7)
            
            if gifReady{
                HStack(spacing: 5) {
                    Text("Fly to You")
                        .font(.italiana(size: 40))
                        .foregroundStyle(.white)
                    Image("paperplane")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                }
                
                Text("“마음을 담은 종이비행기를 접어서, \n누군가에게 날려보내는 감정 표현\"")
                    .font(.pretendard(.ultraLight, size: 20))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .offset(y: 200)
            }
        }
    }
}



