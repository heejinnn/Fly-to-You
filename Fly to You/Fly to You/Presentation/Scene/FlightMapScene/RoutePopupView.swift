//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct RoutePopupView: View {
    @Binding var isPresented: Bool
    let route: ReceiveLetterModel
    
    var body: some View {
        VStack {
            PaperPlaneCheck(letter: route)
        }
        .padding(.vertical, Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
    }
}
