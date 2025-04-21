//
//  PaperPlaneCheck.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

struct PaperPlaneCheck: View{
    
    let letter: ReceiveLetterModel
    
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
                Text("To. \(letter.to.nickname)")
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
                .frame(height: 300, alignment: .top)
        }
        .padding(.horizontal, 15)
        .padding(.top, 5)
        .background{
            Image(.backgroundPaper)
                .resizable()
        }
    }
}

#Preview {
    PaperPlaneCheck(letter: ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "ddd", createdAt: Date()), to: User(uid: "", nickname: "ddd", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false))
}
