//
//  FlightMapCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct FlightMapCell: View{
    let flight: FlightModel
    let onSpotTap: (ReceiveLetterModel) -> Void
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 2)
            
            
            VStack(spacing: Spacing.xs){
                Text(flight.topic)
                    .font(.pretendard(.semibold, size: 15))
                HStack(spacing: Spacing.xxs){
                    Text("시작일: \(DateUtil.formatLetterDate(flight.startDate))")
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
                                        SpotButton(route: route) {
                                            onSpotTap(route)
                                        }
                                        Spacer()
                                    } else{
                                        Spacer()
                                        SpotButton(route: route) {
                                            onSpotTap(route)
                                        }
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
                    .padding(.top, 10)
            }
        }
        .frame(height: 350)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Spacing.md)
    }
}

struct SpotButton: View {
    
    let route: ReceiveLetterModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack {
                Image(.iconMap)
                    .resizable()
                    .frame(width: 37, height: 37)
                Text(route.from.nickname)
                    .font(.pretendard(.regular, size: 12))
            }
        }
        .buttonStyle(.plain)
    }
}


