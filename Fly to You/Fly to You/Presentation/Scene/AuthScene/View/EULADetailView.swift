//
//  EULADetailView.swift
//  Fly to You
//
//  Created by 최희진 on 8/16/25.
//

import SwiftUI

struct EULADetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(EULAContent.content)
                        .font(.pretendard(.regular, size: 14))
                        .lineSpacing(4)
                        .padding(.horizontal, Spacing.md)
                        .padding(.vertical, Spacing.sm)
                }
            }
            .navigationTitle("사용권 계약")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            }
        
    }
}
