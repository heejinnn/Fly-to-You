//
//  FlyAnimationView.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI

struct FlyAnimationView: View {
    @State private var gifName: String = GifName.flyPlane
    @State private var text: String = "열심히 날아가는 중..."
    @State private var isPresented: Bool = false
    
    let onHome: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            GifPlayer(gifName: gifName)
                .frame(width: isPresented ? 250 : nil, height: isPresented ? 250 : 300)
                .padding(isPresented ? 50 : 0)
            
            Text("\(text)")
                .font(.pretendard(.regular, size: 20))
                .foregroundStyle(.gray3)
            
            Spacer()
            
            if isPresented{
                BottomButton(title: "홈 화면으로", action: {
                    onHome()
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                isPresented = true
                gifName = GifName.completeFlyPlane
                text = "전송 완료!"
            }
        }
    }
}

enum GifName {
    static let flyPlane = "fly_plane"
    static let completeFlyPlane = "complete_fly_plane"
}
