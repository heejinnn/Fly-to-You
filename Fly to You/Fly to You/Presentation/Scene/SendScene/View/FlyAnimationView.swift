//
//  FlyAnimationView.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI

struct FlyAnimationView: View {
    @State private var gifName: String = "fly_plane"
    @State private var text: String = "열심히 날라가는 중..."
    @State private var isPresented: Bool = false
    
    var body: some View {
        VStack {
            
            GifPlayer(gifName: gifName)
                .frame(width: 300, height: 300)
                .border(.black)
            
            Text("\(text)")
                .font(.pretendard(.regular, size: 20))
                .foregroundStyle(.gray3)
            if isPresented{
                Button(action: {
                    
                }, label: {
                    Text("")
                })
            }
        }
        .onAppear {

            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                isPresented = true
                gifName = "complete_fly_plane" // 원하는 GIF 이름으로 변경
                text = "전송 완료!"
            }
        }
    }
}

#Preview {
    FlyAnimationView()
}
