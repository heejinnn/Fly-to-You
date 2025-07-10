//
//  PaperPlaneCheck.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

struct PaperPlaneCheck: View{
    
    let letter: ReceiveLetterModel
    let showReportIcon: Bool
    @Binding var showReportModal: Bool
    
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
                
                Menu {
                    Button(role: .destructive, action: {
                        showReportModal = true
                    }, label: {
                        HStack {
                            Text("신고하기")
                        }
                    })
                } label: {
                    Image(.kebabmenu)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 10)
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
    PaperPlaneCheck(letter: ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "ddd", createdAt: Date(), fcmToken: ""), to: User(uid: "", nickname: "ddd", createdAt: Date(), fcmToken: ""), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), showReportIcon: true, showReportModal: .constant(false))
}
