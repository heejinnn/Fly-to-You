//
//  PlaneCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//


import SwiftUI

struct PlaneCell: View{
    
    let letter: ReceiveLetterModel
    var participantCount: Int = 0
    let route: PlaneCellRoute
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 2)
            
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxxs) {
                    Text("\(letter.topic)")
                        .font(.pretendard(.medium, size: 18))
                    
                    switch route {
                    case .receive:
                        Text("From: \(letter.from.nickname)")
                            .font(.pretendard(.regular, size: 13))
                    case .send:
                        Text("To: \(letter.to.nickname)")
                            .font(.pretendard(.regular, size: 13))
                    case .map:
                        Text("참가자: \(participantCount)명")
                            .font(.pretendard(.regular, size: 13))
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Image(.paperplane)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Spacer()
                    Text("\(DateUtil.convertToDateString(letter.timestamp))")
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

//#Preview {
//    PlaneCell()
//}
