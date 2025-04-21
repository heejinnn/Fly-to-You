//
//  PlaneCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//


import SwiftUI

struct PlaneCell: View{
    
    let letter: ReceiveLetterModel
    let route: PlaneCellRoute
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .gray3.opacity(0.3), radius: 1, x: 1, y: 2)
            
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xxxs) {
                    Text("\(letter.topic)")
                        .font(.pretendard(.medium, size: 18))
                    
                    if route == .receive {
                        Text("From: \(letter.from.nickname)")
                            .font(.pretendard(.regular, size: 13))
                    } else{
                        Text("To: \(letter.to.nickname)")
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
                    Text("\(DateUtil.formatLetterDate(letter.timestamp))")
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

enum PlaneCellRoute{
    case receive
    case send
}

//#Preview {
//    PlaneCell()
//}
