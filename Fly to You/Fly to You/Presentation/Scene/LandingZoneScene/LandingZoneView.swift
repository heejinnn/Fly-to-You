//
//  LandingZoneView.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI

struct LandingZoneView: View {
    
    let letters: [ReceiveLetter] = [ReceiveLetter(id: "1", from: User(uid: "1", nickname: "누구", createdAt: Date()), to: User(uid: "2", nickname: "누구2", createdAt: Date()), message: "내용", topic: "주제", topicId: "2", timestamp: Date()), ReceiveLetter(id: "1", from: User(uid: "1", nickname: "누구", createdAt: Date()), to: User(uid: "2", nickname: "누구2", createdAt: Date()), message: "내용", topic: "주제", topicId: "2", timestamp: Date()), ReceiveLetter(id: "1", from: User(uid: "1", nickname: "누구", createdAt: Date()), to: User(uid: "2", nickname: "누구2", createdAt: Date()), message: "내용", topic: "주제", topicId: "2", timestamp: Date()), ReceiveLetter(id: "1", from: User(uid: "1", nickname: "누구", createdAt: Date()), to: User(uid: "2", nickname: "누구2", createdAt: Date()), message: "내용", topic: "주제", topicId: "2", timestamp: Date()), ReceiveLetter(id: "1", from: User(uid: "1", nickname: "누구", createdAt: Date()), to: User(uid: "2", nickname: "누구2", createdAt: Date()), message: "내용", topic: "주제", topicId: "2", timestamp: Date())]
    
    var body: some View {
        NavigationStack {
            
            Spacer().frame(height: Spacing.lg)
            
            Text("도착한 종이 비행기들이 여기에 착륙해요")
                .font(.pretendard(.medium, size: 15))
                .foregroundStyle(.gray3)
            
            Spacer().frame(height: Spacing.lg)
            
            VStack(spacing: Spacing.xs){
                ForEach(letters, id: \.id){ letter in
                    PlaneCell(letter: letter)
                }
            }
            .navigationDestination(for: LandingZoneRoute.self) { route in
                switch route {
                case .landingZoneInfo:
                    LetterInfoView(letter: <#ReceiveLetter#>)
                }
            }
        }
    }
}


enum LandingZoneRoute: Hashable {
    case landingZoneInfo
}
