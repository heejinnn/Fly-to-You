//
//  PlaneCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//


import SwiftUI

struct PlaneCell: View{
    
    let letter: ReceiveLetter = ReceiveLetter(id: "1", from: User(uid: "1", nickname: "누구", createdAt: Date()), to: User(uid: "2", nickname: "누구2", createdAt: Date()), message: "내용", topic: "주제", topicId: "2", timestamp: Date())
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 2)
            
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxxs) {
                    Text("\(letter.topic)")
                        .font(.pretendard(.medium, size: 18))
                    Text("From: \(letter.from.nickname)")
                        .font(.pretendard(.regular, size: 13))
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Image("paperplane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                    Text("2025.04.03")
                        .font(.pretendard(.thin, size: 13))
                }
            }
            .padding(.vertical, Spacing.sm)
            .padding(.horizontal, Spacing.sm)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(.horizontal, Spacing.md)
    }
}

#Preview {
    PlaneCell()
}

struct ReceiveLetter: Codable {
    let id: String
    let from: User
    let to: User
    let message: String
    let topic: String
    let topicId: String
    let timestamp: Date
}
