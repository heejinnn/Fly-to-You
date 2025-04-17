//
//  LetterInfoView.swift
//  Fly to You
//
//  Created by 최희진 on 4/17/25.
//

import SwiftUI

struct LetterInfoView: View{
    
    let letter: ReceiveLetterModel
    
    var body: some View{
        VStack{
            ExplanationText(text: "비행기를\n이어서 날려보세요")
            
            PaperPlaneCheck(letter: letter)
            
            Spacer()
        }
    }
}
