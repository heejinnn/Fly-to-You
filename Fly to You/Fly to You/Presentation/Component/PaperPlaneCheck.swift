//
//  PaperPlaneCheck.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

struct PaperPlaneCheck: View{
    
    let letter: ReceiveLetter
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Text("주제: \"\(letter.topic)\"")
                      .font(.pretendard(.light, size: 15))
                      .foregroundColor(.white)
                      .padding(.vertical, 15)
                      .padding(.leading, 15)
                      .background(.blue1)
                  
                  Spacer()
              }
              .background(.blue1)
            
            content
            
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.md)
        .shadow(radius: 3)
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text("To.\(letter.to.nickname)")
                    .font(.gaRamYeonGgoc(size: 18))
            }
            .padding(.top, 10)

            Text("From. \(letter.from.nickname)")
                .font(.gaRamYeonGgoc(size: 18))
                .foregroundColor(.black)
            
            Divider()
            
            Text(letter.message)
                .font(.gaRamYeonGgoc(size: 20))
                .multilineTextAlignment(.leading)
                .frame(height: 300)
        }
        .padding(.horizontal, 15)
        .padding(.top, 5)
        .background(.white)
    }
}
