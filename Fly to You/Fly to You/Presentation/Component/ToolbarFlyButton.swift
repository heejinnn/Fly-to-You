//
//  ToolbarFlyButton.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

struct ToolbarFlyButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 0){
                Text("날리기")
                    .foregroundStyle(.blue1)
                Image(systemName: "paperplane")
            }
        })
    }
}
