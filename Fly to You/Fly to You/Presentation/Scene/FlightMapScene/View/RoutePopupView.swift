//
//  Untitled.swift
//  Fly to You
//
//  Created by 최희진 on 4/22/25.
//

import SwiftUI

struct RoutePopupView: View {
    @Binding var showReportModal: Bool
    @Binding var showBlockAlert: Bool
    let route: ReceiveLetterModel
    
    var body: some View {
        VStack {
            PaperPlaneCheck(letter: route, showReportIcon: true, showReportModal: $showReportModal, showBlockAlert: $showBlockAlert)
        }
        .padding(.vertical, Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
    }
}
