//
//  FlightMapCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct FlightMapCell: View{
    let flight: FlightModel
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 2)
            
            
            VStack(spacing: Spacing.xs){
                Text(flight.topic)
                    .font(.pretendard(.semibold, size: 15))
                HStack(spacing: Spacing.xxs){
                    Text("시작일: \(DateUtil.formatLetterDate(flight.stratDate))")
                        .font(.pretendard(.medium
                                          , size: 12))
                    Text("참여자: \(flight.routes.count)명")
                        .font(.pretendard(.medium, size: 12))
                }
                
                ZStack{
                    Image(.backgroundMap)
                        .resizable()
                        .scaledToFit()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: Spacing.xl){
                            ForEach(Array(flight.routes.enumerated()), id: \.element.id) { index, route in
                                VStack {
                                    if index % 2 == 0 {
                                        Image(.iconMap)
                                            .resizable()
                                            .frame(width: 37, height: 37)
                                        
                                        Text(route.from.nickname)
                                            .font(.pretendard(.regular, size: 12))
                                        Spacer()
                                    } else{
                                        Spacer()
                                        
                                        Image(.iconMap)
                                            .resizable()
                                            .frame(width: 37, height: 37)
                                        
                                        Text(route.from.nickname)
                                            .font(.pretendard(.regular, size: 12))
                                       
                                    }
                                    
                                }
                                .frame(height: 150)
                            }
                        }
                        .padding(.horizontal, Spacing.xxl)
                    }
                }
                
                Text("이 릴레이는 현재 진행 중입니다. 참여하려면 비행기를 받아보세요!")
                    .font(.pretendard(.regular, size: 12))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.md)
    }
}

#Preview {
    FlightMapCell(flight: FlightModel(id: UUID().uuidString, topic: "응원", stratDate: Date(), routes: [ReceiveLetterModel(id: "1", from: User(uid: "", nickname: "happy", createdAt: Date()), to: User(uid: "", nickname: "ddd", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: true, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "ddd", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sad", createdAt: Date()), to: User(uid: "", nickname: "sss", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false), ReceiveLetterModel(id:  UUID().uuidString, from: User(uid: "", nickname: "sss", createdAt: Date()), to: User(uid: "", nickname: "sad", createdAt: Date()), message: "mmmm", topic: "tttt", topicId: "1", timestamp: Date(), isDelivered: false, isRelayStart: false)]))
}
