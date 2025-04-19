//
//  ExplanationCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct ExplanationText: View {
    
    let text: String
    
    var body: some View {
        VStack{
            HStack{
                Text("\(text)")
                    .font(.pretendard(.regular, size: 20))
                    .foregroundStyle(.gray3)
                Spacer()
            }
            .padding(.horizontal, Spacing.md)
        }
        .padding(.vertical, 25)
    }
}
