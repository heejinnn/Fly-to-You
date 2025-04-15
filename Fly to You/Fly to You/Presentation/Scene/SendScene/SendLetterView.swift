//
//  SendLetter.swift
//  Fly to You
//
//  Created by 최희진 on 4/15/25.
//

import SwiftUI

struct SendLetterView: View{
    
    @EnvironmentObject var viewModelWrapper: MainViewModelWrapper
    
    let topic: String
    @State private var toText: String = ""
    @State private var fromText: String = ""
    @State private var message: String = ""
    
    @StateObject private var viewModel = SendLetterViewModel()
    
    var body: some View{
        VStack{
            
            ExplanationText(text: "주제에 맞는\n내용을 입력해 보세요")
            
            LetterInput(topic: topic, toText: $toText,fromText: fromText, message: $message)
        
            Spacer()
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                HStack(spacing: 0){
                    Text("날리기")
                        .foregroundStyle(.blue1)
                    Image(systemName: "paperplane")
                }
            }
        }
    }
}

#Preview {
    SendLetterView(topic: "")
}
