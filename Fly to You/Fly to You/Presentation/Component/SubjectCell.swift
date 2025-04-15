//
//  SubjectCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SubjectCell: View {
    let text: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text("“\(text)” ")
                .font(.pretendard(.light, size: 15))
                .foregroundColor(.black)
                .padding(.leading, 15)

            Spacer()
        }
        .frame(height: 55)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .inset(by: 0.5)
                .stroke(isSelected ? .blue1 : .gray1, lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SubjectCell(text: "응원 한마디", isSelected: false)
}
