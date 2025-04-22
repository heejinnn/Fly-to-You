//
//  ExplanationCell.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct ExplanationText: View {
    
    let originalText: String
    let boldSubstring: String
    
    var body: some View {
        VStack{
            HStack{
                TextWithBoldSubstring(originalText: originalText, boldSubstring: boldSubstring)
                Spacer()
            }
            .padding(.horizontal, Spacing.md)
        }
        .padding(.vertical, 25)
    }
}

struct TextWithBoldSubstring: View {
    var originalText: String
    var boldSubstring: String
    
    var body: some View {
        if let coloredRange = originalText.range(of: boldSubstring) {
            let beforeRange = originalText[..<coloredRange.lowerBound]
            let coloredText = originalText[coloredRange]
            let afterRange = originalText[coloredRange.upperBound...]
            
            return Text(beforeRange)
                    .font(.pretendard(.regular, size: 20))
                    .foregroundStyle(.gray3)
                + Text(coloredText)
                    .font(.pretendard(.bold, size: 20))
                    .foregroundStyle(.gray3)
                + Text(afterRange)
                    .font(.pretendard(.regular, size: 20))
                    .foregroundStyle(.gray3)
        } else {
            return Text(originalText)
                .foregroundColor(.black)
        }
    }
}

#Preview{
    TextWithColoredSubstring(originalText: "마음에 드는 주제를 선택하세요", boldSubstring: "주제")
}
