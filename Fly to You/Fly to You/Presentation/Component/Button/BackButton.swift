//
//  BackButton.swift
//  Fly to You
//
//  Created by 최희진 on 4/21/25.
//

import SwiftUI

struct BackButton: View{
    
    let action: () -> Void
    
    var body: some View{
        Button(action: {
            action()
        }) {
            Image(.arrowLeft)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
        }
    }
}
