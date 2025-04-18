//
//  DepartureLogView.swift
//  Fly to You
//
//  Created by 최희진 on 4/18/25.
//

import SwiftUI

struct DepartureLogView: View {
    
    let letter: [ReceiveLetterModel] = [ReceiveLetterModel(id: "1", from: User(uid: "1", nickname: "nick", createdAt: Date()), to: User(uid: "1", nickname: "nick", createdAt: Date()), message: "ddd", topic: "topic", topicId: "11", timestamp: Date(), isDelivered: true, isRelayStart: true), ReceiveLetterModel(id: "1", from: User(uid: "1", nickname: "nick", createdAt: Date()), to: User(uid: "1", nickname: "nick", createdAt: Date()), message: "ddd", topic: "topic", topicId: "11", timestamp: Date(), isDelivered: true, isRelayStart: true)]
    
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer().frame(height: Spacing.lg)
                
                Text("도착한 종이 비행기들이 여기에 착륙해요")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                
                Spacer().frame(height: Spacing.lg)
                
                VStack{
                    ForEach(letter, id: \.id){ letter in
                        PlaneCell(letter: letter, route: .send)
                    }
                }
                
                Spacer()
            }
        }
    }
}

class DepatureLogViewModelWrapper: ObservableObject {
    
}

#Preview {
    DepartureLogView()
}
