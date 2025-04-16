//
//  PlaneButton.swift
//  Fly to You
//
//  Created by 최희진 on 4/16/25.
//

import SwiftUI

struct PlaneButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.pretendard(.ultraLight, size: 18))
                .foregroundColor(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.blue1)
                .cornerRadius(10)
        }
        .padding(.horizontal, Spacing.md)
        .buttonStyle(.plain)
    }
}
