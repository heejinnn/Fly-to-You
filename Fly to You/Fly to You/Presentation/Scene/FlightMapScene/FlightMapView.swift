//
//  FlightMapView.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct FlightMapView: View{
    
    private let segmentedMenu = ["진행 중인 항로", "완료된 항로"]
    @State private var selectedTab = "진행 중인 항로"
    let data = [ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "happy", createdAt: Date()), to: User(uid: "", nickname: "ddd", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: true, isRelayStart: false), ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "ddd", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false)]
    
    var body: some View{
        NavigationStack{
            VStack(spacing: Spacing.md){
                Text("도착한 종이 비행기들이 여기에 착륙해요")
                    .font(.pretendard(.medium, size: 15))
                    .foregroundStyle(.gray3)
                 
                Picker("", selection: $selectedTab){
                    ForEach(segmentedMenu, id: \.self){
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Spacing.md)
                
                
                ForEach(data, id: \.id){ item in
                    PlaneCell(letter: item, route: .receive)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    FlightMapView()
}
