//
//  SubjectCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SubjectCell: View{
    
    let text: String
    
    var body: some View{
        ZStack{
            
            Button(action: {
                
            }, label: {
                HStack{
                    Text("“\(text)” ")
                        .font(.pretendard(.light, size: 15))
                        .foregroundColor(.gray1)
                        .padding(.leading, 15)
                    
                    Spacer()
                }
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .inset(by: 0.5)
                        .stroke(.gray1, lineWidth: 1)
                )
            })
            .padding(.horizontal, 20)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    SubjectCell(text: "응원 한마디")
}
